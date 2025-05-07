import SwiftUI
import SnapdexUseCases

@MainActor
public struct AppCoordinator: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var appSettings = AppSettings()
    
    private let deps: AppDependencies
    
    public init(deps: AppDependencies) {
        self.deps = deps
    }
    
    public var body: some View {
        Group {
            if (isLoggedIn) {
                MainScreen(deps: deps)
            } else if (hasSeenIntro) {
                AuthCoordinator(
                    deps: deps,
                    didLogin: {
                        isLoggedIn = true
                    }
                )
            } else {
                IntroScreen {
                    hasSeenIntro = true
                }
            }
        }
        .environment(appSettings)
        .environment(\.locale, appSettings.locale)
    }
}
