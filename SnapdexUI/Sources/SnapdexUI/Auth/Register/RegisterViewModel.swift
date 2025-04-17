import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable class RegisterViewModel {
    var avatar: AvatarId = -1 {
        didSet { validateForm() }
    }
    var name = "" {
        didSet { validateForm() }
    }
    var email = "" {
        didSet { validateForm() }
    }
    var password = "" {
        didSet { validateForm() }
    }
    var passwordValidationState = PasswordValidationState()
    var canRegister = false
    var isRegistering = false
    var error: LocalizedStringKey? = nil
    
    let didRegister = PassthroughSubject<Void, Never>()
    
    private let authService: AuthService
    private let userDataValidator: UserDataValidator
    
    init(authService: AuthService, userDataValidator: UserDataValidator) {
        self.authService = authService
        self.userDataValidator = userDataValidator
    }
    
    private func validateForm() {
        passwordValidationState = userDataValidator.validatePassword(password)
        
        canRegister =
            avatar > -1
            && userDataValidator.validateName(name)
            && userDataValidator.validateEmail(email)
            && passwordValidationState.isValid
    }
    
    func register() async {
        isRegistering = true
        
        let result = await authService.register(
            avatarId: avatar,
            name: name,
            email: email,
            password: password
        )
        
        isRegistering = false
        
        switch result {
            case .success(_): didRegister.send()
            case .failure(.registerFailed): error = "Failed to register"
            case .failure(.invalidEmail): error = "Invalid email format"
            case .failure(.invalidPassword): error = "Password is too weak"
            case .failure(.emailAlreadyUsed): error = "Email already used"
        }
    }
}
