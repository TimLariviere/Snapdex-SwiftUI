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
    public init() {}
    
    public func login(email: String, password: String) async -> Result<Void, LoginError> {
        do {
            try await Task.sleep(for: .seconds(5))
            return .failure(.loginFailed)
        } catch {
            return .failure(.loginFailed)
        }
    }
    
    public func sendPasswordResetEmail(email: String) async -> Result<Void, SendPasswordResetEmailError> {
        do {
            try await Task.sleep(for: .seconds(5))
            return .failure(.sendFailed)
        } catch {
            return .failure(.sendFailed)
        }
    }
    
    public func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, RegisterError> {
        do {
            try await Task.sleep(for: .seconds(5))
            return .failure(.registerFailed)
        } catch {
            return .failure(.registerFailed)
        }
    }
}
