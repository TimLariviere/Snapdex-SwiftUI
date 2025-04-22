import SwiftUI

public struct SnapdexFloatingActionButton : View {
    let onClick : () -> Void
    
    @Environment(\.theme) private var theme
    
    public init(onClick: @escaping () -> Void) {
        self.onClick = onClick
    }
    
    public var body: some View {
        Button {
            onClick()
        } label: {
            SnapdexIcon(.pokeball)
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.onPrimary)
                .frame(width: 56, height: 56)
                .background(theme.colors.primary)
                .clipShape(Circle())
                .shadow(radius: 6)
        }
    }
}

#Preview {
    AppTheme {
        SnapdexFloatingActionButton {}
    }
}
