import SwiftUI

struct LoginScreen: View {
    private let onRegisterClick: () -> Void
    private let onForgotPasswordClick: () -> Void
    private let onLoginSuccessful: () -> Void
    
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: LoginViewModel

    init(container: Container, onRegisterClick: @escaping () -> Void, onForgotPasswordClick: @escaping () -> Void, onLoginSuccessful: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: LoginViewModel(container: container))
        self.onRegisterClick = onRegisterClick
        self.onForgotPasswordClick = onForgotPasswordClick
        self.onLoginSuccessful = onLoginSuccessful
    }
    
    var body: some View {
        SnapdexBackground {
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 84, height: 84)
                    
                    Text("Snapdex".uppercased())
                        .fontStyle(theme.typography.heading1)
                }
                
                VStack(spacing: 16) {
                    SnapdexTextField(
                        text: $viewModel.email,
                        hint: "Email",
                        keyboardType: .emailAddress
                    )
                    
                    SnapdexPasswordField(
                        text: $viewModel.password,
                        hint: "Password"
                    )
                    
                    SnapdexLinkButton("Forgot password?") {
                        onForgotPasswordClick()
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    SnapdexPrimaryButton("Log in", enabled: viewModel.canLogin, isBusy: viewModel.isLoginIn) {
                        viewModel.login()
                    }
                    
                    SnapdexLinkButton("Create an account") {
                        onRegisterClick()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .onReceive(viewModel.didLogin) { result in
            onLoginSuccessful()
        }
    }
}

#Preview {
    PreviewView {
        LoginScreen(
            container: Container(),
            onRegisterClick: {},
            onForgotPasswordClick: {},
            onLoginSuccessful: {}
        )
    }
}
