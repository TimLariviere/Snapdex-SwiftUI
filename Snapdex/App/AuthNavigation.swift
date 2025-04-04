import SwiftUI

enum AuthNavigationPath {
    case login
    case register
    case forgotPassword
    case main
}

struct AuthNavigation: View {
    @Environment(\.theme) private var theme
    @State private var path: [AuthNavigationPath] = []
    
    private let container: Container
    private let hasSeenIntro: Bool
    private let onIntroCompleted: () -> Void
    private let onLoggedIn: () -> Void
    
    init(container: Container, hasSeenIntro: Bool, onIntroCompleted: @escaping () -> Void, onLoggedIn: @escaping () -> Void) {
        self.container = container
        self.hasSeenIntro = hasSeenIntro
        self.onIntroCompleted = onIntroCompleted
        self.onLoggedIn = onLoggedIn
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !hasSeenIntro {
                    IntroScreen(onContinue: onIntroCompleted)
                } else {
                    loginScreen
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(for: AuthNavigationPath.self) { destination in
                switch destination {
                    case .login:
                        loginScreen
                    case .register:
                        RegisterScreen(
                            onSuccessfulRegistration: {
                                
                            }
                        )
                        .navigationBarBackButtonHidden()
                        .navigationBarTitleDisplayMode(.inline)
                    case .forgotPassword:
                        ForgotPasswordScreen()
                        .navigationBarBackButtonHidden()
                        .navigationBarTitleDisplayMode(.inline)
                    case .main:
                        MainScreen()
                }
            }
        }
        .onAppear {
            let typography = theme.typography.heading2
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor(theme.colors.onBackground),
                .font: UIFont(name: "Poppins-Medium", size: CGFloat(typography.fontSize))!
            ]
            
            UINavigationBar.appearance().standardAppearance = appearance
        }
    }
    
    var loginScreen: some View {
        LoginScreen(
            container: container,
            onRegisterClick: {
                path.append(.register)
            },
            onForgotPasswordClick: {
                path.append(.forgotPassword)
            },
            onLoginSuccessful: {
                onLoggedIn()
            }
        )
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}
