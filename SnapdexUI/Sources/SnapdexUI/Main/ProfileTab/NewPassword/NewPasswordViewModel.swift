import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class NewPasswordViewModel {
    var oldPassword: String {
        didSet {
            validateForm()
        }
    }
    var newPassword: String {
        didSet {
            validateForm()
        }
    }
    var newPasswordValidationState: PasswordValidationState
    var canChangePassword: Bool
    var isChangingPassword: Bool
    var error: String?
    
    @ObservationIgnored let didChangePassword = PassthroughSubject<Void, Never>()
    
    @ObservationIgnored private let userDataValidator: UserDataValidator
    @ObservationIgnored private let userServicing: UserServicing
    
    init(deps: AppDependencies) {
        self.userDataValidator = deps.userDataValidator
        self.userServicing = deps.userServicing
        
        self.oldPassword = ""
        self.newPassword = ""
        self.newPasswordValidationState = PasswordValidationState(hasMinLength: false, hasDigit: false, hasLowercase: false, hasUppercase: false)
        self.canChangePassword = false
        self.isChangingPassword = false
        self.error = nil
    }
    
    private func validateForm() {
        newPasswordValidationState = userDataValidator.validatePassword(newPassword)
        canChangePassword = oldPassword.isNotBlank && newPasswordValidationState.isValid
    }
    
    func setPassword() async {
        isChangingPassword = true
        let result = await userServicing.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        isChangingPassword = false
        
        switch result {
            case .success(()): didChangePassword.send(())
            case .failure(let error):
                switch error {
                    case .invalidNewPassword: self.error = "Old password is invalid"
                    case .invalidOldPassword: self.error = "New password is too weak"
                    case .updatePasswordFailed: self.error = "Failed to change password"
                }
        }
    }
}
