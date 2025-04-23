import Combine

public enum CreateUserError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
    case invalidEmailError
    case emailAlreadyUsedError
}

public enum SignInError : Error {
    case failure(Error)
    case networkError
    case invalidCredentialsError
}

public enum AuthSendPasswordResetEmailError : Error {
    case failure(Error)
    case networkError
    case noSuchEmailError
    case invalidEmailError
}

public enum ReauthenticateError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
    case invalidEmailError
}

public enum UpdatePasswordError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
}

public protocol AuthProvider: Sendable {
    func getCurrentUserId() -> UserId?
    func getCurrentUserIdAsPublisher() -> AnyPublisher<UserId?, Never>
    func createUser(withEmail email: String, password: String) async -> Result<UserId, CreateUserError>
    func signIn(withEmail email: String, password: String) async -> Result<UserId, SignInError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, AuthSendPasswordResetEmailError>
    func signOut() async
    func deleteCurrentUser() async
    func reauthenticate(email: String, password: String) async -> Result<Void, ReauthenticateError>
    func updatePasswordForCurrentUser(newPassword: String) async -> Result<Void, UpdatePasswordError>
}
