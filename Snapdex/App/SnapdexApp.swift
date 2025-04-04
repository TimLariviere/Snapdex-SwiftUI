import SwiftUI
import Firebase

@main
struct SnapdexApp: App {
    init() {
        FirebaseApp.configure()
    }
    
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
