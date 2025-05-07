import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain
import SnapdexUseCases

struct ForgotPasswordScreen: View {
    @Environment(\.theme) private var theme
    @Environment(Router<AuthDestination>.self) private var router
    @State private var viewModel: ForgotPasswordViewModel
    @State private var showEmailSentDialog: Bool = false
    
    init(deps: AppDependencies) {
        _viewModel = State(initialValue: ForgotPasswordViewModel(deps: deps))
    }
    
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
        .overlay {
            if showEmailSentDialog {
                emailSentDialog
            }
        }
        .onReceive(viewModel.didSendEmail) {
            showEmailSentDialog = true
        }
    }
    
    var emailSentDialog: some View {
        SnapdexPopup(
            title: "Password Reset",
            description: "Please check your email for the link to reset your password.",
            onDismiss: {
                router.pop()
            },
            primaryButton: PopupButton(text: "OK") {
                router.pop()
            }
        )
    }
}

#Preview {
    AppTheme {
        ForgotPasswordScreen(deps: MockAppDependencies.shared)
    }
}
