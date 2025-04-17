import SwiftUI

@MainActor
public struct AppCoordinator: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    public init() {}
    
    public var body: some View {
        if (isLoggedIn) {
            Text("Main")
        } else if (hasSeenIntro) {
            AuthCoordinator(didLogin: {
                isLoggedIn = true
            })
        } else {
            IntroScreen {
                hasSeenIntro = true
            }
        }
    }
}
