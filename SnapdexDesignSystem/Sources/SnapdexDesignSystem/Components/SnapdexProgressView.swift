import SwiftUI

public struct SnapdexProgressView: View {
    @Environment(\.theme) private var theme
    
    public init() {
        
    }
    
    public var body: some View {
        ProgressView()
            .tint(theme.colors.primary)
    }
}

#Preview {
    AppTheme {
        SnapdexProgressView()
    }
}
