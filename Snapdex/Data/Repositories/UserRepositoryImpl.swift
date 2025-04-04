import Combine

class UserRepositoryImpl: UserRepository {
    private let authService: AuthService
    private let database: SnapdexDatabase
    private let localUsers: LocalUserDataSource
    
    init(authService: AuthService, database: SnapdexDatabase, localUsers: LocalUserDataSource) {
        self.authService = authService
        self.database = database
        self.localUsers = localUsers
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
        Result.failure(.loginFailed)
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
