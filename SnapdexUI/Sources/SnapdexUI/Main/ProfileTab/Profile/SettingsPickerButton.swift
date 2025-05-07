import SwiftUI
import SnapdexDesignSystem

struct SettingsPickerButton: View {
    @Environment(\.theme) private var theme
    
    let text: String
    let value: String
    let onClick: () -> Void
    
    init(text: String, value: String, onClick: @escaping () -> Void) {
        self.text = text
        self.value = value
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack {
                Text(text)
                
                Spacer()
                
                Text(value)
                    .fontStyle(theme.typography.smallLabel)
                    .foregroundStyle(theme.colors.onBackground)
            }
            .padding(20)
            .frame(height: 44)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AppTheme {
        SettingsPickerButton(text: "Settings", value: "Nothing") {
            
        }
    }
}
