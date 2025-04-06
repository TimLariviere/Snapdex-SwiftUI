import SwiftUI
import FirebaseAuth

struct NavigationRoot: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    var body: some View {
        if isLoading {
            Text("")
                .onAppear {
                    self.isLoggedIn = Auth.auth().currentUser != nil
                    self.isLoading = false
                }
        } else if !hasSeenIntro {
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
