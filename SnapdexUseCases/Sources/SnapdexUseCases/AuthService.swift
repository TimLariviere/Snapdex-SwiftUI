import SnapdexDomain
import Combine

public enum LoginError: Error {
    case loginFailed
    case invalidCredentials
}

public enum SendPasswordResetEmailError: Error {
    case sendFailed
    case noSuchEmail
    case invalidEmail
}

public enum RegisterError: Error {
    case registerFailed
    case invalidPassword
    case invalidEmail
    case emailAlreadyUsed
}

public enum DeleteCurrentUserError: Error {
    case deleteFailed
}

public protocol AuthServicing: Sendable {
    func isLoggedIn() async -> Bool
    func getCurrentUserPublisher() -> AnyPublisher<User?, Never>
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError>
    func login(email: String, password: String) async -> Result<Void, LoginError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError>
    func logout() async
    func deleteCurrentUser() async -> Result<Void, DeleteCurrentUserError>
}

public final class AuthService: AuthServicing {
    private let analyticsTracker: AnalyticsTracker
    private let crashReporter: CrashReporter
    private let authProvider: AuthProvider
    private let localUsers: LocalUserDataSource
    private let localUserPokemons: LocalUserPokemonDataSource
    private let remoteUsers: RemoteUserDataSource
    private let remoteUserPokemons: RemoteUserPokemonDataSource
    
    public init(analyticsTracker: AnalyticsTracker, crashReporter: CrashReporter, authProvider: AuthProvider, localUsers: LocalUserDataSource, localUserPokemons: LocalUserPokemonDataSource, remoteUsers: RemoteUserDataSource, remoteUserPokemons: RemoteUserPokemonDataSource) {
        self.analyticsTracker = analyticsTracker
        self.crashReporter = crashReporter
        self.authProvider = authProvider
        self.localUsers = localUsers
        self.localUserPokemons = localUserPokemons
        self.remoteUsers = remoteUsers
        self.remoteUserPokemons = remoteUserPokemons
    }
    
    public func isLoggedIn() async -> Bool {
        await authProvider.getCurrentUserId() != nil
    }
    
    public func getCurrentUserPublisher() -> AnyPublisher<User?, Never> {
        authProvider.getCurrentUserIdAsPublisher()
            .flatMap { userId in
                if let userId = userId {
                    return self.localUsers.observeById(userId: userId)
                        .map { $0.value }
                        .catch { error -> AnyPublisher<User?, Never> in
                            self.crashReporter.recordException(error: error, metadata: nil)
                            return Just(nil).eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError> {
        do {
            let timestamp = getTimestamp()
            
            let userIdResult = await retryOnCondition {
                await self.authProvider.createUser(withEmail: email, password: password)
            } shouldRetry: { $0.isNetworkError }

            guard case let .success(userId) = userIdResult else {
                let err: RegisterError
                
                if case let .failure(error) = userIdResult {
                    switch error {
                        case .invalidPasswordError: err = .invalidPassword
                        case .invalidEmailError: err = .invalidEmail
                        case .emailAlreadyUsedError: err = .emailAlreadyUsed
                        case .networkError: err = .registerFailed
                        case .failure(let actualError):
                            crashReporter.recordException(error: actualError, metadata: ["email": email])
                            err = .registerFailed
                    }
                } else {
                    err = .registerFailed
                }
                
                return .failure(err)
            }
            
            analyticsTracker.setUserId(userId: userId)
            
            let user = Synced(value: User(id: userId, avatarId: avatarId, name: name, email: email), createdAt: timestamp, updatedAt: timestamp)
            
            try await localUsers.upsert(user: user)
            
            let remoteResult: Result<Void, UpsertRemoteUserError> = await retryOnCondition {
                await self.remoteUsers.upsert(user: user)
            } shouldRetry: {  $0.isNetworkError }

            if case let .failure(error) = remoteResult {
                switch error {
                    case .networkError: ()
                    case .failure(let actualError): crashReporter.recordException(error: actualError, metadata: ["email": email])
                }
            }
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: ["email": email])
            return .failure(.registerFailed)
        }
    }
    
    public func login(email: String, password: String) async -> Result<Void, LoginError> {
        do {
            let userIdResult = await retryOnCondition {
                await self.authProvider.signIn(withEmail: email, password: password)
            } shouldRetry: { $0.isNetworkError }

            guard case let .success(userId) = userIdResult else {
                let err: LoginError
                
                if case let .failure(error) = userIdResult {
                    switch error {
                        case .invalidCredentialsError: err = .invalidCredentials
                        case .networkError: err = .loginFailed
                        case .failure(let actualError):
                            crashReporter.recordException(error: actualError, metadata: [ "email": email ])
                            err = .loginFailed
                    }
                } else {
                    err = .loginFailed
                }
                
                return .failure(err)
            }

            analyticsTracker.setUserId(userId: userId)
            
            let remoteUserResult = await retryOnCondition {
                await self.remoteUsers.getById(userId: userId)
            } shouldRetry: { $0.isNetworkError }

            guard case let .success(remoteUser) = remoteUserResult else {
                if case let .failure(error) = remoteUserResult {
                    switch error {
                        case .networkError: ()
                        case .failure(let actualError):
                            crashReporter.recordException(error: actualError, metadata: ["userId": userId])
                    }
                }
                
                return .failure(.loginFailed)
            }
            
            guard let remoteUser = remoteUser else {
                analyticsTracker.logEvent(name: "user_not_found_in_remote", parameters: ["email": email])
                return .failure(.loginFailed)
            }
            
            // Remote doesn't provide email address, so we inject it here
            let user = Synced(
                value: User(
                    id: remoteUser.value.id,
                    avatarId: remoteUser.value.avatarId,
                    name: remoteUser.value.name,
                    email: email
                ),
                createdAt: remoteUser.createdAt,
                updatedAt: remoteUser.updatedAt
            )
            
            let remoteUserPokemonsResult = await retryOnCondition {
                await self.remoteUserPokemons.getAllForUser(userId: userId)
            } shouldRetry: { $0.isNetworkError }

            let remoteUserPokemons = switch remoteUserPokemonsResult {
                case .success(let pokemons): pokemons
                case .failure(_): [Synced<PokemonId>]()
            }

            try await localUsers.upsert(user: user)
            try await localUserPokemons.upsertAll(userId: userId, pokemons: remoteUserPokemons)

            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: ["email": email])
            return .failure(.loginFailed)
        }
    }
    
    public func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError> {
        let sendResult = await retryOnCondition {
            await self.authProvider.sendPasswordResetEmail(email: email)
        } shouldRetry: { $0.isNetworkError }
        
        let res: Result<Void, SendPasswordResetEmailError>
        
        switch sendResult {
            case .success(_): res = .success(())
            case .failure(.invalidEmailError): res = .failure(.invalidEmail)
            case .failure(.noSuchEmailError): res = .failure(.noSuchEmail)
            case .failure(.networkError): res = .failure(.sendFailed)
            case .failure(.failure(let actualError)):
                crashReporter.recordException(error: actualError, metadata: ["email": email])
                res = .failure(.sendFailed)
        }
        
        return res
    }
    
    public func logout() async {
        await authProvider.signOut()
        analyticsTracker.setUserId(userId: nil)
    }
    
    public func deleteCurrentUser() async -> Result<Void, DeleteCurrentUserError> {
        do {
            guard let userId = await authProvider.getCurrentUserId() else {
                analyticsTracker.logEvent(name: "no_current_user", parameters: nil)
                return .failure(.deleteFailed)
            }
            
            let remoteDeletePokemonsResult = await retryOnCondition {
                await self.remoteUserPokemons.deleteAllForUser(userId: userId)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = remoteDeletePokemonsResult {
                if case let .failure(actualError) = error {
                    crashReporter.recordException(error: actualError, metadata: nil)
                }
                return .failure(.deleteFailed)
            }
            
            let remoteDeleteUserResult = await retryOnCondition {
                await self.remoteUsers.delete(userId: userId)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = remoteDeleteUserResult {
                if case let .failure(actualError) = error {
                    crashReporter.recordException(error: actualError, metadata: nil)
                }
                return .failure(.deleteFailed)
            }
            
            try await localUserPokemons.deleteAllForUser(userId: userId)
            try await localUsers.delete(userId: userId)
            await authProvider.deleteCurrentUser()
            
            analyticsTracker.setUserId(userId: nil)
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: nil)
            return .failure(.deleteFailed)
        }
    }
}
