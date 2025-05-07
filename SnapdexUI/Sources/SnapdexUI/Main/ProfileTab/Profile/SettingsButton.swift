import SwiftUI
import SnapdexDesignSystem

struct SettingsButton: View {
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
                .padding(20)
                .frame(height: 44)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AppTheme {
        SettingsButton(text: "Settings") {
            
        }
    }
}
