import SwiftUI
import Firebase
import SnapdexDesignSystem
import SnapdexUI

@main
struct SnapdexApp: App {
    let configuration = Configuration()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppTheme {
                //AppCoordinator(deps: configuration)
                PokedexScreen()
            }
        }
    }
}
