import SwiftUI
import SnapdexDesignSystem

struct SmallTypeBadge : View {
    let typeUi: TypeUi
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        typeUi.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color("OnType", bundle: .module))
            .padding(.all, 2)
            .background(typeUi.color)
            .clipShape(Circle())
            .frame(width: 16, height: 16)
    }
}

#Preview {
    AppTheme {
        VStack(spacing: 4) {
            SmallTypeBadge(typeUi: TypeUi.fromType(.fire))
            SmallTypeBadge(typeUi: TypeUi.fromType(.water))
            SmallTypeBadge(typeUi: TypeUi.fromType(.rock))
            SmallTypeBadge(typeUi: TypeUi.fromType(.grass))
        }
    }
}
