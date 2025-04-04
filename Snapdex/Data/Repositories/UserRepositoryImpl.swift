import Combine

class UserRepositoryImpl: UserRepository {
    func observeCurrentUser() -> AnyPublisher<User?, any Error> {
        Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError> {
        Result.success(())
    }
    
    func login(email: String, password: String) async -> Result<Void, LoginError> {
        Result.success(())
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError> {
        Result.success(())
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
