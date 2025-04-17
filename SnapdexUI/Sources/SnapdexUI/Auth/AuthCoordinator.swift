import SwiftUI
import SnapdexDesignSystem

enum AuthDestination: Hashable {
    case register
    case forgotPassword
}

public struct AuthCoordinator: View {
    @State private var router = Router<AuthDestination>()
    
    let didLogin: @MainActor () -> Void
    
    public init(didLogin: @MainActor @escaping () -> Void) {
        self.didLogin = didLogin
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            LoginScreen(didLogin: {
                didLogin()
            })
                .navigationDestination(for: AuthDestination.self) { destination in
                    switch destination {
                        case .register: RegisterScreen(didRegister: {
                            didLogin()
                        })
                        case .forgotPassword: ForgotPasswordScreen()
                    }
                }
                .environment(router)
        }
    }
}

#Preview {
    AppTheme {
        AuthCoordinator(didLogin: {})
    }
}
