import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct DataCardItem : View {
    let icon: String
    let name: LocalizedStringKey
    let value: String
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(icon, bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text(name)
                    .textCase(.uppercase)
                    .fontStyle(theme.typography.smallLabel)
            }
            
            Text(value)
                .fontStyle(theme.typography.largeLabel)
        }
        .foregroundStyle(theme.colors.onSurface)
        .padding(.all, 8)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.regular)
        .overlay {
            theme.shapes.regular
                .stroke(theme.colors.outline, lineWidth: 1)
        }
    }
}

#Preview {
    AppTheme {
        SnapdexBackground {
            DataCardItem(icon: "Weight", name: "Weight", value: "100.0 kg")
                .padding(.all, 20)
        }
    }
}
