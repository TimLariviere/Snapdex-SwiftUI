import SwiftUI
import Firebase
import SnapdexDesignSystem
import SnapdexUI

@main
struct SnapdexApp: App {
    let configuration: Configuration
    
    init() {
        FirebaseApp.configure()
        self.configuration = Configuration()
    }
    
    var body: some Scene {
        WindowGroup {
            AppTheme {
                AppCoordinator(deps: configuration)
            }
        }
    }
}
