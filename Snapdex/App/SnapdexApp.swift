import SwiftUI

@main
struct SnapdexApp: App {
    var body: some Scene {
        let theme = Theme()
        
        WindowGroup {
            LoginScreen()
                .environment(\.theme, theme)
                .foregroundStyle(theme.colors.onBackground)
                .fontStyle(theme.typography.paragraph)
        }
    }
}
