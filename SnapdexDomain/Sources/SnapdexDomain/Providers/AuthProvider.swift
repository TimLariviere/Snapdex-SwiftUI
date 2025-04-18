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

public protocol AuthProvider: Sendable {
    var currentUserId: UserId? { get async }
    func createUser(withEmail email: String, password: String) async -> Result<UserId, CreateUserError>
    func signIn(withEmail email: String, password: String) async -> Result<UserId, SignInError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, AuthSendPasswordResetEmailError>
}
