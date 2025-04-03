import SwiftUI

struct SnapdexProgressView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ProgressView()
            .tint(theme.colors.primary)
    }
}

#Preview {
    SnapdexProgressView()
}
