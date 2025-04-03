import SwiftUI

struct SnapdexBackground<Content: View>: View {
    private let content: () -> Content
    @Environment(\.theme) private var theme
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    theme.colors.background,
                    theme.colors.backgroundVariant
                ],
                startPoint: UnitPoint.topLeading,
                endPoint: UnitPoint.bottomTrailing
            )
            .ignoresSafeArea()
            
            content()
        }
    }
}

#Preview {
    let theme = Theme()
    
    SnapdexBackground {
        Text("Hello")
    }
    .foregroundStyle(theme.colors.onBackground)
    .fontStyle(theme.typography.paragraph)
    .environment(\.theme, theme)
}
