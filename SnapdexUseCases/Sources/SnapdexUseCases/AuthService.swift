import SnapdexDomain

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

public protocol AuthServicing: Sendable {
    func login(email: String, password: String) async -> Result<Void, LoginError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError>
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError>
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
    
    public func login(email: String, password: String) async -> Result<Void, LoginError> {
        do {
            let userId = try await authProvider.signIn(withEmail: email, password: password).get()

            analyticsTracker.setUserId(userId: userId)
            
            guard let remoteUser = try await remoteUsers.getById(userId: userId).get() else {
                return .failure(.loginFailed)
            }
            
            let remoteUserPokemons = try await remoteUserPokemons.getAllForUser(userId: userId).get()

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

            try await localUsers.upsert(user: user)
            try await localUserPokemons.upsertAll(userId: userId, pokemons: remoteUserPokemons)

            return .success(())
        } catch let signInError as SignInError {
            // TODO: log to Crashlytics or print
            return .failure(.loginFailed)
        } catch {
            crashReporter.recordException(error: error, metadata: ["email": email])
            return .failure(.loginFailed)
        }
    }
    
    public func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError> {
        do {
            try await Task.sleep(for: .seconds(5))
            return .failure(.sendFailed)
        } catch {
            crashReporter.recordException(error: error, metadata: ["email": email])
            return .failure(.sendFailed)
        }
    }
    
    public func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError> {
        do {
            try await Task.sleep(for: .seconds(5))
            return .failure(.registerFailed)
        } catch {
            crashReporter.recordException(error: error, metadata: ["name": name, "email": email])
            return .failure(.registerFailed)
        }
    }
}
