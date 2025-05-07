import SwiftUI
import SnapdexDesignSystem

struct DestructiveSettingsButton: View {
    @Environment(\.theme) private var theme
    
    let text: String
    let onClick: @MainActor () -> Void
    
    init(text: String, onClick: @MainActor @escaping () -> Void) {
        self.text = text
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .foregroundStyle(theme.colors.error)
                .padding(20)
                .frame(height: 44)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AppTheme {
        DestructiveSettingsButton(text: "Delete") {
            
        }
    }
}
