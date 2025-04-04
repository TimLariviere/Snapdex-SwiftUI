import SwiftUI

enum AuthNavigationPath {
    case register
    case forgotPassword
}

struct AuthNavigation: View {
    @Environment(\.theme) private var theme
    @State private var path: [AuthNavigationPath] = []
    
    private let container: Container
    private let hasSeenIntro: Bool
    private let onLoggedIn: () -> Void
    
    init(container: Container, hasSeenIntro: Bool, onLoggedIn: @escaping () -> Void) {
        self.container = container
        self.hasSeenIntro = hasSeenIntro
        self.onLoggedIn = onLoggedIn
    }
    
    var body: some View {
        NavigationStack(path: $path) {
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
            .navigationDestination(for: AuthNavigationPath.self) { destination in
                switch destination {
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
}
