import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ForgotPasswordViewModel
    @State private var showEmailSent = false
    
    init(container: Container) {
        self._viewModel = StateObject(wrappedValue: ForgotPasswordViewModel(container: container))
    }
    
    var body: some View {
        SnapdexBackground {
            VStack(spacing: 24) {
                Text("We will email you a password reset link")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 84)
                
                SnapdexTextField(
                    text: $viewModel.email,
                    hint: "Email",
                    keyboardType: .emailAddress
                )
                
                Spacer()
                
                errorBanner
                
                SnapdexPrimaryButton(
                    "Send password reset link",
                    enabled: viewModel.canSendEmail,
                    isBusy: viewModel.isSendingEmail
                ) {
                    viewModel.sendPasswordResetEmail()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .navigationTitle("Forgotten Password")
            .toolbar {
                SnapdexBackButton()
            }
        }
        .overlay {
            if (showEmailSent) {
                emailSentDialog
            }
        }
        .onReceive(viewModel.didSentEmail) {
            showEmailSent = true
        }
    }
    
    var emailSentDialog: some View {
        SnapdexPopup(
            title: "Password Reset",
            description: "Please check your email for the link to reset your password.",
            primaryButton: PopupButton(text: "OK") {
                showEmailSent = false
                dismiss()
            }
        )
    }
    
    var errorBanner: some View {
        let errorMessage: String? =
            switch viewModel.sendEmailError {
                case .none: .none
                case .noSuchEmail: "No such email exists"
                case .invalidEmail: "Invalid email format"
                case .sendFailed: "Send password reset email failed"
            }
        
        return ErrorBanner(errorMessage)
    }
}

#Preview {
    PreviewView {
        ForgotPasswordScreen(container: Container())
    }
}
