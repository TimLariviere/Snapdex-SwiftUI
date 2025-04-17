public struct PasswordValidationState {
    public let hasMinLength: Bool
    public let hasDigit: Bool
    public let hasLowercase: Bool
    public let hasUppercase: Bool
    public let isValid: Bool
    
    public init(hasMinLength: Bool = false, hasDigit: Bool = false, hasLowercase: Bool = false, hasUppercase: Bool = false) {
        self.hasMinLength = hasMinLength
        self.hasDigit = hasDigit
        self.hasLowercase = hasLowercase
        self.hasUppercase = hasUppercase
        self.isValid = hasMinLength && hasDigit && hasLowercase && hasUppercase
    }
}
