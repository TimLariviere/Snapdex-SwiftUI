import SwiftUI
import SnapdexDomain
import SnapdexDesignSystem
import SnapdexUseCases

struct RegisterScreen: View {
    let didRegister: @MainActor () -> Void
    
    @Environment(\.theme) private var theme
    @State private var viewModel = RegisterViewModel(authService: AuthService(), userDataValidator: UserDataValidator())
    @State private var isAvatarPickerPresented = false
    
    init(didRegister: @MainActor @escaping () -> Void) {
        self.didRegister = didRegister
    }
    
    var body: some View {
        SnapdexScaffold(title: "Create an account") {
            VStack(spacing: 16) {
                ErrorBanner(viewModel.error)
                
                pickPictureButton
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name")
                        .fontStyle(theme.typography.smallLabel)
                    
                    SnapdexTextField(text: $viewModel.name)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .fontStyle(theme.typography.smallLabel)
                    
                    SnapdexTextField(
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password")
                        .fontStyle(theme.typography.smallLabel)
                    
                    SnapdexPasswordField(text: $viewModel.password)
                    
                    PasswordRequirements(state: viewModel.passwordValidationState)
                }
                
                Spacer()
                
                SnapdexPrimaryButton("Create account", enabled: viewModel.canRegister, isBusy: viewModel.isRegistering) {
                    Task {
                        await viewModel.register()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .sheet(isPresented: $isAvatarPickerPresented) {
            AvatarPicker(avatar: $viewModel.avatar)
        }
        .onReceive(viewModel.didRegister) {
            didRegister()
        }
    }
    
    var pickPictureButton: some View {
        let imageName = viewModel.avatar == -1 ? "Add" : AvatarUi.getFor(id: viewModel.avatar)
        
        return
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFit()
                .padding(.all, 16)
                .foregroundStyle(theme.colors.onSurface)
                .frame(width: 88, height: 88)
                .background(theme.colors.surface)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(theme.colors.outline, lineWidth: 1)
                }
                .onTapGesture {
                    if !viewModel.isRegistering {
                        isAvatarPickerPresented = true
                    }
                }
    }
}

#Preview {
    AppTheme {
        RegisterScreen(didRegister: {})
    }
}
