import SwiftUI
import SnapdexDomain
import SnapdexDesignSystem

struct AvatarView: View {
    let avatarId: AvatarId
    let isSelected: Bool
    
    @Environment(\.theme) private var theme
    
    init(avatarId: AvatarId, isSelected: Bool) {
        self.avatarId = avatarId
        self.isSelected = isSelected
    }
    
    var body: some View {
        Image(AvatarUi.getFor(id: avatarId), bundle: .module)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(theme.colors.surface)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(
                        isSelected ? theme.colors.primary : theme.colors.outline,
                        lineWidth: 1
                    )
            }
    }
}

#Preview {
    AppTheme {
        AvatarView(avatarId: 1, isSelected: false)
        AvatarView(avatarId: 1, isSelected: true)
    }
}
