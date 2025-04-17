import SwiftUI
import Firebase
import SnapdexDesignSystem
import SnapdexUI

@main
struct SnapdexApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        let theme = Theme()
        
        WindowGroup {
            IntroScreen()
                .environment(\.theme, theme)
                .foregroundStyle(theme.colors.onBackground)
                .fontStyle(theme.typography.paragraph)
        }
    }
}
