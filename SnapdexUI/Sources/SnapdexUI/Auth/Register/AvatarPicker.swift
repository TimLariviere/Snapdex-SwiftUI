import SwiftUI
import SnapdexDomain
import SnapdexDesignSystem

struct AvatarPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding private var avatar: AvatarId
    @State private var selected: AvatarId
    
    @Environment(\.theme) private var theme
    
    init(avatar: Binding<AvatarId>) {
        self._avatar = avatar
        self.selected = avatar.wrappedValue
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Pick your avatar")
                .fontStyle(theme.typography.heading3)
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 16) {
                ForEach(0..<10) { index in
                    let isSelected = index == selected
                    
                    AvatarView(avatarId: index, isSelected: isSelected)
                        .onTapGesture {
                            selected = index
                        }
                }
            }
            
            Spacer()
            
            SnapdexPrimaryButton("Use Avatar", enabled: selected > -1) {
                avatar = selected
                dismiss()
            }
        }
        .padding(.all, 16)
        .background(theme.colors.surfaceVariant)
    }
}

#Preview {
    AppTheme {
        AvatarPicker(avatar: .constant(1))
    }
}
