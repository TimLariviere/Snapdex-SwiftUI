import Combine

public enum CreateUserError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
    case invalidEmailError
    case emailAlreadyUsedError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum SignInError : Error {
    case failure(Error)
    case networkError
    case invalidCredentialsError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum AuthSendPasswordResetEmailError : Error {
    case failure(Error)
    case networkError
    case noSuchEmailError
    case invalidEmailError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum ReauthenticateError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
    case invalidEmailError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum UpdatePasswordError : Error {
    case failure(Error)
    case networkError
    case invalidPasswordError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public protocol AuthProvider: Sendable {
    func getCurrentUserId() async -> UserId?
    func getCurrentUserIdAsPublisher() -> AnyPublisher<UserId?, Never>
    func createUser(withEmail email: String, password: String) async -> Result<UserId, CreateUserError>
    func signIn(withEmail email: String, password: String) async -> Result<UserId, SignInError>
    func sendPasswordResetEmail(email: String) async -> Result<Void, AuthSendPasswordResetEmailError>
    func signOut() async
    func deleteCurrentUser() async
    func reauthenticate(email: String, password: String) async -> Result<Void, ReauthenticateError>
    func updatePasswordForCurrentUser(newPassword: String) async -> Result<Void, UpdatePasswordError>
}
