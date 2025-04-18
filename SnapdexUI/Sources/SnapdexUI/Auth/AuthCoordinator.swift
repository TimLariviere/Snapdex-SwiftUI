import SwiftUI
import SnapdexDesignSystem
import SnapdexUseCases

enum AuthDestination: Hashable {
    case register
    case forgotPassword
}

public struct AuthCoordinator: View {
    @State private var router = Router<AuthDestination>()
    
    let deps: AppDependencies
    let didLogin: @MainActor () -> Void
    
    public init(deps: AppDependencies, didLogin: @MainActor @escaping () -> Void) {
        self.deps = deps
        self.didLogin = didLogin
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            LoginScreen(
                deps: deps,
                didLogin: {
                    didLogin()
                }
            )
                .navigationDestination(for: AuthDestination.self) { destination in
                    switch destination {
                        case .register: RegisterScreen(
                            deps: deps,
                            didRegister: {
                                didLogin()
                            }
                        )
                        case .forgotPassword: ForgotPasswordScreen(deps: deps)
                    }
                }
                .environment(router)
        }
    }
}

#Preview {
    AppTheme {
        AuthCoordinator(
            deps: MockAppDependencies.shared,
            didLogin: {}
        )
    }
}
