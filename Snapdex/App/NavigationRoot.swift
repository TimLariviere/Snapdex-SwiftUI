import SwiftUI

struct NavigationRoot: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    var body: some View {
        if isLoggedIn {
            MainNavigation(
                container: container,
                onLoggedOut: {
                    isLoggedIn = false
                }
            )
        } else {
            AuthNavigation(
                container: container,
                hasSeenIntro: hasSeenIntro,
                onIntroCompleted: {
                    hasSeenIntro = true
                },
                onLoggedIn: {
                    isLoggedIn = true
                }
            )
        }
    }
}
