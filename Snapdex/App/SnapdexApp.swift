import SwiftUI

@main
struct SnapdexApp: App {
    var body: some Scene {
        let theme = Theme()
        let container = Container()
        
        WindowGroup {
            NavigationRoot(container: container)
                .environment(\.theme, theme)
                .foregroundStyle(theme.colors.onBackground)
                .fontStyle(theme.typography.paragraph)
        }
    }
}
