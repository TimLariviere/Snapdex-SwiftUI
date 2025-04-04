import SwiftUI

struct NavigationRoot: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    var body: some View {
        if !hasSeenIntro {
            IntroScreen(
                onContinue: {
                    hasSeenIntro = true
                }
            )
        } else if !isLoggedIn {
            AuthNavigation(
                container: container,
                hasSeenIntro: hasSeenIntro,
                onLoggedIn: {
                    isLoggedIn = true
                }
            )
        } else {
            MainNavigation(
                container: container,
                onLoggedOut: {
                    isLoggedIn = false
                }
            )
        }
    }
}
