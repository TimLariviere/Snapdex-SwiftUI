import SwiftUI

public struct SnapdexHorizontalDivider: View {
    @Environment(\.theme) private var theme
    
    public init() {}
    
    public var body: some View {
        Divider()
            .foregroundStyle(theme.colors.outline)
    }
}
