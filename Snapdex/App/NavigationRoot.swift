import SwiftUI

enum RootNavigation {
    case login
    case register
    case forgotPassword
}

struct NavigationRoot: View {
    @Environment(\.theme) private var theme
    @State private var path: [RootNavigation] = []
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !hasSeenIntro {
                    IntroScreen(
                        onContinue: {
                            hasSeenIntro = true
                        }
                    )
                } else {
                    LoginScreen(
                        onRegisterClick: {
                            path.append(.register)
                        },
                        onForgotPasswordClick: {
                            path.append(.forgotPassword)
                        }
                    )
                }
            }
            .navigationDestination(for: RootNavigation.self) { destination in
                switch destination {
                    case .login:
                        LoginScreen(
                            onRegisterClick: {
                                path.append(.register)
                            },
                            onForgotPasswordClick: {
                                path.append(.forgotPassword)
                            }
                        )
                        .navigationBarBackButtonHidden()
                        .navigationBarTitleDisplayMode(.inline)
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
            .navigationBarBackButtonHidden()
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
