import SwiftUI
import SnapdexDomain
import SnapdexDesignSystem

struct PasswordRequirements: View {
    let state: PasswordValidationState
    
    init(state: PasswordValidationState) {
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
    let text: LocalizedStringKey
    let isValid: Bool
    
    @Environment(\.theme) private var theme
    
    init(text: LocalizedStringKey, isValid: Bool) {
        self.text = text
        self.isValid = isValid
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(isValid ? "Check" : "Close", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(isValid ? theme.colors.success : theme.colors.error)
            
            Text(text)
        }
    }
}

#Preview {
    AppTheme {
        PasswordRequirements(state: PasswordValidationState())
    }
}
