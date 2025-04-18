import SnapdexDomain
import SnapdexUseCases

final class MockAuthService: AuthServicing {
    func login(email: String, password: String) async -> Result<Void, SnapdexUseCases.LoginError> {
        return .success(())
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, SnapdexUseCases.SendPasswordResetEmailError> {
        return .success(())
    }
    
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, SnapdexUseCases.RegisterError> {
        return .success(())
    }
}

final class MockAppDependencies : AppDependencies {
    static let shared = MockAppDependencies()
    
    let _authServicing = MockAuthService()
    var authServicing: AuthServicing { _authServicing }
    
    let _userDataValidator = UserDataValidator()
    var userDataValidator: UserDataValidator { _userDataValidator }
}
