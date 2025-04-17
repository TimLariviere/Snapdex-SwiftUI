import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable class ForgotPasswordViewModel {
    var email = "" {
        didSet { validateForm() }
    }
    var canSendEmail = false
    var isSendingEmail = false
    var error: LocalizedStringKey?

    let didSendEmail = PassthroughSubject<Void, Never>()
    
    private let authService: AuthService
    private let userDataValidator: UserDataValidator
    
    init(authService: AuthService, userDataValidator: UserDataValidator) {
        self.authService = authService
        self.userDataValidator = userDataValidator
    }
    
    private func validateForm() {
        canSendEmail = userDataValidator.validateEmail(email)
    }
    
    func sendEmail() async {
        isSendingEmail = true
        
        let result = await authService.sendPasswordResetEmail(email: email)
        
        isSendingEmail = false
        
        switch result {
            case .success(_): didSendEmail.send()
            case .failure(.invalidEmail): error = "Invalid email format"
            case .failure(.noSuchEmail): error = "No such email exists"
            case .failure(.sendFailed): error = "Send password reset email failed"
        }
    }
}
