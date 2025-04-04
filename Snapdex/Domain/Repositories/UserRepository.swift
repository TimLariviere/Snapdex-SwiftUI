import Combine

enum RegisterError : Error {
    case accountCreationFailed
    case invalidPassword
    case invalidEmail
    case emailAlreadyUsed
}

enum LoginError: Error {
    case loginFailed
    case invalidCredentials
}

enum SendPasswordResetEmailError: Error {
    case noSuchEmail
    case invalidEmail
    case sendFailed
}

enum DeleteCurrentUserError: Error {
    case deleteFailed
}

enum ChangeNameError: Error {
    case changeFailed
}

enum ChangePasswordError: Error {
    case invalidOldPassword
    case invalidNewPassword
    case updatePasswordFailed
}

protocol UserRepository {
    func observeCurrentUser() -> AnyPublisher<User?, Error>
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError>
    func login(email: String, password: String) async -> Result<Void, LoginError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError>
    func logout() async
    func deleteCurrentUser() async -> Result<Void, DeleteCurrentUserError>
    func changeName(newName: String) async -> Result<Void, ChangeNameError>
    func changePassword(oldPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError>
}
