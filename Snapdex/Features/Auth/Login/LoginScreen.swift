import SwiftUI

struct LoginScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel = LoginViewModel()
    
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
                        hint: "Email"
                    )
                    
                    SnapdexPasswordField(
                        text: $viewModel.password,
                        hint: "Password"
                    )
                    
                    SnapdexLinkButton("Forgot password?") {
                        
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    SnapdexPrimaryButton("Log in", enabled: viewModel.canLogin, isBusy: viewModel.isLoginIn) {
                        viewModel.login()
                    }
                    
                    SnapdexLinkButton("Create an account") {
                        
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    PreviewView {
        LoginScreen()
    }
}
