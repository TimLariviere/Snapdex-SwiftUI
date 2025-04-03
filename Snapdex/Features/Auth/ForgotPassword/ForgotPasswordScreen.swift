import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @State private var showEmailSent = false
    
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
                
                SnapdexPrimaryButton(
                    "Send password reset link",
                    enabled: viewModel.canSendEmail,
                    isBusy: viewModel.isSendingEmail
                ) {
                    Task { @MainActor in
                        let result = await viewModel.sendPasswordResetEmail()
                        showEmailSent = result
                    }
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
}

#Preview {
    PreviewView {
        ForgotPasswordScreen()
    }
}
