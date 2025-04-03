import SwiftUI

struct PasswordRequirements: View {
    private var state: PasswordValidationState
    
    init(_ state: PasswordValidationState) {
        self.state = state
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PasswordRequirement(text: "At least 9 characters", isValid: state.hasMinLength)
            PasswordRequirement(text: "At least 1 number", isValid: state.hasDigit)
            PasswordRequirement(text: "Contains lowercase character", isValid: state.hasLowercase)
            PasswordRequirement(text: "Contains uppercase character", isValid: state.hasUppercase)
        }
    }
}

struct PasswordRequirement: View {
    private var text: String
    private var isValid: Bool = false
    
    @Environment(\.theme) private var theme
    
    init(text: String, isValid: Bool) {
        self.text = text
        self.isValid = isValid
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(isValid ? "Check" : "Close")
                .resizable()
                .scaledToFit()
                .foregroundStyle(isValid ? theme.colors.success : theme.colors.error)
                .frame(width: 20, height: 20)
            
            Text(text)
        }
    }
}

#Preview {
    PreviewView {
        PasswordRequirements(
            PasswordValidationState(
                hasMinLength: true,
                hasDigit: false,
                hasLowercase: false,
                hasUppercase: true
            )
        )
    }
}
