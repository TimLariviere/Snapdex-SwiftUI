import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain
//import Flow

struct TypeTag : View {
    let typeUi: TypeUi
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        HStack(spacing: 8) {
            typeUi.image
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(typeUi.color)
            
            Text(typeUi.name)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.small)
        .overlay {
            theme.shapes.small
                .stroke(theme.colors.outline, lineWidth: 1)
        }
    }
}

#Preview {
    AppTheme {
        SnapdexBackground {
            TypeTag(typeUi: TypeUi.fromType(.bug))
        }
    }
}
