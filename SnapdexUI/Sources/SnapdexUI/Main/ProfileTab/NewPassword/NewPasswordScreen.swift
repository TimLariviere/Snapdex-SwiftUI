import SwiftUI
import SnapdexDesignSystem

struct NewPasswordScreen: View {
    @Environment(Router<ProfileTabDestination>.self) private var router
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @State private var viewModel: NewPasswordViewModel
    @State private var showPasswordChangedPopup: Bool = false
    
    init(deps: AppDependencies) {
        self._viewModel = State(initialValue: NewPasswordViewModel(deps: deps))
    }
    
    var body: some View {
        SnapdexScaffold(title: "New password") {
            VStack(spacing: 8) {
                SnapdexPasswordField(text: $viewModel.oldPassword, hint: "Old password")
                SnapdexPasswordField(text: $viewModel.newPassword, hint: "New password")
                
                PasswordRequirements(state: viewModel.newPasswordValidationState)
                
                Spacer()
                
                SnapdexPrimaryButton("Set new password", enabled: viewModel.canChangePassword, isBusy: viewModel.isChangingPassword) {
                    Task {
                        await viewModel.setPassword()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .overlay {
            if showPasswordChangedPopup {
                passwordChangedPopup
            }
        }
        .onReceive(viewModel.didChangePassword) {
            showPasswordChangedPopup = true
        }
        .onAppear {
            navBarVisibility.isVisible = false
        }
    }
    
    var passwordChangedPopup: some View {
        SnapdexPopup(
            title: "Password Changed",
            description: "Your password has been changed.",
            onDismiss: {
                showPasswordChangedPopup = false
                router.pop()
            },
            primaryButton: PopupButton(text: "OK") {
                showPasswordChangedPopup = false
                router.pop()
            }
        )
    }
}
