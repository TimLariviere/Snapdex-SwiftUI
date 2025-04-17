import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain
import SnapdexUseCases

struct ForgotPasswordScreen: View {
    @Environment(\.theme) private var theme
    @State private var viewModel = ForgotPasswordViewModel(
        authService: AuthService(),
        userDataValidator: UserDataValidator()
    )
    
    var body: some View {
        SnapdexScaffold(title: "Forgotten Password") {
            VStack(spacing: 24) {
                Text("We will email you a password reset link")
                    .multilineTextAlignment(.center)
                
                SnapdexTextField(
                    text: $viewModel.email,
                    hint: "Email",
                    keyboardType: .emailAddress
                )
                
                Spacer()
                
                SnapdexPrimaryButton("Send password reset link", enabled: viewModel.canSendEmail, isBusy: viewModel.isSendingEmail) {
                    Task {
                        await viewModel.sendEmail()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 84)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    AppTheme {
        ForgotPasswordScreen()
    }
}
