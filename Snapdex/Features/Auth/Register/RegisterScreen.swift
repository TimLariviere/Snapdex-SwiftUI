import SwiftUI

struct RegisterScreen: View {
    private let onSuccessfulRegistration: () -> Void
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var showAvatarPicker = false
    @Environment(\.theme) private var theme
    
    init(onSuccessfulRegistration: @escaping () -> Void) {
        self.onSuccessfulRegistration = onSuccessfulRegistration
    }
    
    var body: some View {
        SnapdexBackground {
            VStack(spacing: 16) {
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
                    
                    SnapdexPasswordField(
                        text: $viewModel.password
                    )
                    
                    PasswordRequirements(viewModel.passwordValidationState)
                }
                
                Spacer()
                
                SnapdexPrimaryButton(
                    "Create account",
                    enabled: viewModel.canRegister,
                    isBusy: viewModel.isRegistering
                ) {
                    viewModel.register()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(selectedIndex: viewModel.avatar) {
                    viewModel.pickAvatar($0)
                    showAvatarPicker = false
                }
                .presentationDetents([.fraction(0.75)])
            }
            .navigationTitle("Create an account")
            .toolbar {
                SnapdexBackButton()
            }
            .onReceive(viewModel.didRegister) {
                onSuccessfulRegistration()
            }
        }
    }
    
    var pickPictureButton: some View {
        Group {
            if (viewModel.avatar == -1) {
                Image("Add")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(theme.colors.onSurface)
                    .padding(20)
            } else {
                AvatarImage(id: viewModel.avatar)
                    .padding(16)
            }
        }
        .background(theme.colors.surface)
        .overlay {
            Circle()
                .stroke(theme.colors.outline, lineWidth: 1)
        }
        .clipShape(Circle())
        .frame(width: 88, height: 88)
        .onTapGesture {
            showAvatarPicker = true
        }
    }
}

#Preview {
    PreviewView {
        RegisterScreen(
            onSuccessfulRegistration: {}
        )
    }
}
