import SwiftUI

struct SnapdexTextField: View {
    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var hint: LocalizedStringKey
    
    init(text: Binding<String>, hint: LocalizedStringKey) {
        self._text = text
        self.hint = hint
    }
    
    var body: some View {
        TextField("", text: $text, prompt: Text(hint).foregroundStyle(theme.colors.onSurfaceVariant))
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
}

#Preview {
    PreviewView {
        SnapdexTextField(text: Binding.constant(""), hint: "Email")
            .padding(.horizontal, 40)
    }
}
