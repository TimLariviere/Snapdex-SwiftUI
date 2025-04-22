import SwiftUI
import SnapdexDesignSystem

struct SearchView : View {
    @Binding var text: String
    var hint: String
    @FocusState private var focused: Bool
    
    @Environment(\.theme) private var theme
    
    init(text: Binding<String>, hint: String) {
        self._text = text
        self.hint = hint
    }
    
    var body: some View {
        HStack(spacing: 8) {
            SnapdexIcon(.search)
                .foregroundStyle(theme.colors.onSurfaceVariant)
            
            SearchTextField(text: $text, hint: hint, focused: $focused)
        }
        .padding(16)
        .frame(height: 44)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay {
            RoundedRectangle(cornerRadius: 40)
                .stroke(focused ? theme.colors.primary : theme.colors.outline)
        }
    }
}

struct SearchTextField : View {
    @Binding var text: String
    var hint: String
    var focused: FocusState<Bool>.Binding
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        TextField("", text: $text, prompt: Text(hint).foregroundStyle(theme.colors.onSurfaceVariant))
            .lineLimit(1)
            .foregroundStyle(theme.colors.onSurface)
            .focused(focused)
    }
}

#Preview {
    AppTheme {
        SnapdexBackground {
            SearchView(
                text: .constant(""),
                hint: "Search Pokémon..."
            )
            .padding(.horizontal, 16)
        }
    }
}
