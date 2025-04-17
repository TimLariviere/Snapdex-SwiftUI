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
        WindowGroup {
            AppTheme {
                IntroScreen()
            }
        }
    }
}
