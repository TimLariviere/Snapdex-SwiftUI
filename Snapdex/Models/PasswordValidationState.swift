struct PasswordValidationState {
    let hasMinLength: Bool
    let hasDigit: Bool
    let hasLowercase: Bool
    let hasUppercase: Bool
    let isValid: Bool
    
    init(hasMinLength: Bool = false, hasDigit: Bool = false, hasLowercase: Bool = false, hasUppercase: Bool = false) {
        self.hasMinLength = hasMinLength
        self.hasDigit = hasDigit
        self.hasLowercase = hasLowercase
        self.hasUppercase = hasUppercase
        self.isValid = hasMinLength && hasDigit && hasLowercase && hasUppercase
    }
}
