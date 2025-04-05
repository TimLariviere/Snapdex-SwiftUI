import Combine
import FirebaseAnalytics
import FirebaseCrashlytics

class UserRepositoryImpl: UserRepository {
    private let crashlytics: Crashlytics
    private let authService: AuthService
    private let database: SnapdexDatabase
    private let localUsers: LocalUserDataSource
    private let localUserPokemons: LocalUserPokemonDataSource
    private let remoteUsers: RemoteUserDataSource
    private let remoteUserPokemons: RemoteUserPokemonDataSource
    
    init(crashlytics: Crashlytics, authService: AuthService, database: SnapdexDatabase, localUsers: LocalUserDataSource, localUserPokemons: LocalUserPokemonDataSource, remoteUsers: RemoteUserDataSource, remoteUserPokemons: RemoteUserPokemonDataSource) {
        self.crashlytics = crashlytics
        self.authService = authService
        self.database = database
        self.localUsers = localUsers
        self.localUserPokemons = localUserPokemons
        self.remoteUsers = remoteUsers
        self.remoteUserPokemons = remoteUserPokemons
    }
    
    func observeCurrentUser() -> AnyPublisher<User?, Error> {
        authService.$currentUser
            .flatMap { user in
                guard let user = user else {
                    return Just<User?>(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return self.localUsers.observeById(id: user.uid)
                    .publisher(in: self.database.dbQueue)
                    .map { userEntity -> User? in
                        if let userEntity = userEntity {
                            return User(id: userEntity.id, avatarId: userEntity.avatarId, name: userEntity.name, email: userEntity.email)
                        } else {
                            return nil
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError> {
        Result.failure(.emailAlreadyUsed)
    }
    
    func login(email: String, password: String) async -> Result<Void, LoginError> {
        let authResult = await authService.signIn(withEmail: email, password: password)
        
        guard case .success(let auth) = authResult else {
            if case let .failure(error) = authResult {
                switch error {
                    case .firebase(.invalidCredential): return .failure(.invalidCredentials)
                    case .firebase(.networkError): return .failure(.loginFailed)
                    default:
                        crashlytics.record(error: error, userInfo: ["email": email])
                        return .failure(.loginFailed)
                }
            }
            return .failure(.loginFailed)
        }
        
        let userId = auth.user.uid
        Analytics.setUserID(userId)
        
        let remoteUserResult = await remoteUsers.get(id: userId)
        
        guard case .success(let remoteUser?) = remoteUserResult else {
            switch remoteUserResult {
                case .success(nil):
                    Analytics.logEvent("user_not_found_in_remote", parameters: ["email": email ])
                case .failure(let error):
                    switch error {
                        case .firestore(.cancelled), .firestore(.unavailable), .firestore(.deadlineExceeded): ()
                        default: crashlytics.record(error: error, userInfo: ["userId": userId])
                    }
                default: break
            }
            return .failure(.loginFailed)
        }
        
        let upsertResult = await localUsers.upsert(
            entity: UserEntity(
                id: remoteUser.id!,
                avatarId: remoteUser.avatarId,
                name: remoteUser.name,
                email: email,
                createdAt: remoteUser.createdAt,
                updatedAt: remoteUser.updatedAt
            )
        )
        
        guard case .success(_) = upsertResult else {
            if case let .failure(error) = upsertResult {
                crashlytics.record(error: error)
            }
            return.failure(.loginFailed)
        }

        
        let remoteUserPokemonsResult = await remoteUserPokemons.getAllForUser(userId: userId)

        if case .success(let remoteUserPokemons) = remoteUserPokemonsResult {
            let insertAllResult = await localUserPokemons.insertAll(
                pokemons: remoteUserPokemons.map {
                    UserPokemonEntity(
                        id: nil,
                        userId: $0.userId,
                        pokemonId: $0.pokemonId,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
            
            if case .failure(let error) = insertAllResult {
                crashlytics.record(error: error)
            }
        }
        
        return .success(())
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError> {
        let result = await authService.sendPasswordResetEmail(email: email)
        
        return switch result {
            case .success(_): .success(())
            case .failure(.firebase(.userNotFound)): .failure(.noSuchEmail)
            case .failure(.firebase(.invalidEmail)): .failure(.invalidEmail)
            case .failure(.firebase(.networkError)): .failure(.sendFailed)
            default:
                // Crashlytics here
                .failure(.sendFailed)
        }
    }
    
    func logout() async {
        
    }
    
    func deleteCurrentUser() async -> Result<Void, DeleteCurrentUserError> {
        Result.success(())
    }
    
    func changeName(newName: String) async -> Result<Void, ChangeNameError> {
        Result.success(())
    }
    
    func changePassword(oldPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError> {
        Result.success(())
    }
}
