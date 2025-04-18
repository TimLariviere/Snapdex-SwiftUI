import SwiftUI
import SnapdexDesignSystem
import SnapdexUseCases

struct LoginScreen: View {
    @State private var viewModel : LoginViewModel
    @Environment(\.theme) private var theme
    @Environment(Router<AuthDestination>.self) private var router
    
    let didLogin: @MainActor () -> Void
    
    init(deps: AppDependencies, didLogin: @MainActor @escaping () -> Void) {
        self._viewModel = State(initialValue: LoginViewModel(deps: deps))
        self.didLogin = didLogin
    }
    
    var body: some View {
        SnapdexBackground {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 8) {
                    Image("App", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 84, height: 84)
                    
                    Text("SNAPDEX")
                        .fontStyle(theme.typography.heading1)
                        .foregroundStyle(theme.colors.onSurface)
                }
                
                VStack(spacing: 16) {
                    ErrorBanner(viewModel.error)
                    
                    SnapdexTextField(
                        text: $viewModel.email,
                        hint: "Email",
                        keyboardType: .emailAddress
                    )
                    
                    SnapdexPasswordField(
                        text: $viewModel.password,
                        hint: "Password"
                    )
                    
                    SnapdexLinkButton("Forgot password?", enabled: !viewModel.isLoginIn) {
                        router.push(.forgotPassword)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    SnapdexPrimaryButton("Log in", enabled: viewModel.canLogin, isBusy: viewModel.isLoginIn) {
                        Task {
                            await viewModel.login()
                        }
                    }
                    
                    SnapdexLinkButton("Create an account", enabled: !viewModel.isLoginIn) {
                        router.push(.register)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .onReceive(viewModel.didLogin) {
                didLogin()
            }
        }
    }
}

#Preview {
    AppTheme {
        LoginScreen(
            deps: MockAppDependencies.shared,
            didLogin: {}
        )
    }
}
