import SwiftUI

public struct SnapdexPasswordField: View {
    @Binding var text: String
    var hint: LocalizedStringKey
    
    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    public init(text: Binding<String>, hint: LocalizedStringKey = "") {
        self._text = text
        self.hint = hint
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            if (isPasswordVisible) {
                TextField("", text: $text, prompt: prompt)
            } else {
                SecureField("", text: $text, prompt: prompt)
            }
            
            Button {
                isPasswordVisible = !isPasswordVisible
            } label: {
                Image(isPasswordVisible ? "EyeClosed" : "Eye", bundle: .module)
            }
        }
        .tint(theme.colors.primary)
        .lineLimit(1)
        .focused($isFocused)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 44)
        .foregroundStyle(theme.colors.onSurface)
        .background(theme.colors.surfaceVariant)
        .overlay(
            theme.shapes.regular
                .stroke(
                    isFocused ? theme.colors.primary : theme.colors.outline,
                    lineWidth: 1
                )
        )
        .clipShape(theme.shapes.regular)
    }
    
    var prompt: Text {
        Text(hint)
            .foregroundStyle(theme.colors.onSurfaceVariant)
    }
}

#Preview {
    AppTheme {
        SnapdexPasswordField(text: Binding.constant(""), hint: "Password")
            .padding(.horizontal, 40)
    }
}
