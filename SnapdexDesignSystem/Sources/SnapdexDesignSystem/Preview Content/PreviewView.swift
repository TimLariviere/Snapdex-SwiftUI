import SwiftUI

struct PreviewView<Content: View>: View {
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        let theme = Theme()
        
        SnapdexBackground {
            content()
        }
        .environment(\.theme, theme)
        .foregroundStyle(theme.colors.onBackground)
        .fontStyle(theme.typography.paragraph)
    }
}
