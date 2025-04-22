import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct UnknownItem: View {
    let id: Int
    
    @Environment(\.theme) private var theme
        
    var body: some View {
        VStack(spacing: 4) {
            Text("?")
                .fontStyle(theme.typography.heading1)
                .outlineStroke(width: 4)
                .foregroundStyle(theme.colors.surface)
                .frame(maxHeight: .infinity)
            
            Text(String(format: "%04d", id))
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 8)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.regular)
        .overlay {
            theme.shapes.regular
                .stroke(theme.colors.outline, lineWidth: 1)
        }
    }
}
