import Foundation

class UserDataValidator {
    static func validateName(_ name: String) -> Bool {
        return name.isNotBlank
    }
    
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func validatePassword(_ password: String) -> PasswordValidationState {
        let hasMinLength = password.lengthOfBytes(using: .utf8) > 8
        let hasDigit = password.contains { $0.isNumber }
        let hasLowercase = password.contains { $0.isLowercase }
        let hasUppercase = password.contains { $0.isUppercase }
        
        return PasswordValidationState(
            hasMinLength: hasMinLength,
            hasDigit: hasDigit,
            hasLowercase: hasLowercase,
            hasUppercase: hasUppercase
        )
    }
}
