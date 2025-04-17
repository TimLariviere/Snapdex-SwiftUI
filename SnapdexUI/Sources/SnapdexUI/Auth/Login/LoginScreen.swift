import SwiftUI
import SnapdexDesignSystem
import SnapdexUseCases

struct LoginScreen: View {
    @State private var viewModel = LoginViewModel(authService: AuthService())
    @Environment(\.theme) private var theme
    
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
                        // Navigate to ForgotPassword
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
                        // Navigate to CreateAccount
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .onReceive(viewModel.didLogin) {
                // Navigate to Main
            }
        }
    }
}

#Preview {
    AppTheme {
        LoginScreen()
    }
}
