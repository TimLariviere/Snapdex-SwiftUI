public class AuthService: @unchecked Sendable {
    public enum LoginError: Error {
        case loginFailed
        case invalidCredentials
    }
    
    public init() {}
    
    public func login(email: String, password: String) async -> Result<Void, LoginError> {
        return .failure(.loginFailed)
    }
}
