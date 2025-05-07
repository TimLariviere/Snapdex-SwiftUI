import SwiftUI
import SnapdexDesignSystem

struct ProfileScreen: View {
    @Environment(\.theme) private var theme
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @Environment(Router<ProfileTabDestination>.self) private var router
    @Environment(AppSettings.self) private var appSettings
    
    @State private var viewModel: ProfileViewModel
    
    @State private var showResetProgressDialog = false
    @State private var showDeleteAccountDialog = false
    @State private var showLanguageDialog = false
    
    init(deps: AppDependencies) {
        self._viewModel = State(initialValue: ProfileViewModel(deps: deps))
    }
    
    var body: some View {
        SnapdexScaffold {
            if let _ = viewModel.user {
                VStack(spacing: 16) {
                    userView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            accountSettings
                            applicationSettings
                            about
                            logout
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    callToAction
                }
                .padding(.bottom, 64)
            } else {
                SnapdexProgressView()
            }
        }
        .overlay {
            if showResetProgressDialog {
                resetProgressDialog
            }
            
            if showDeleteAccountDialog {
                accountDeletionConfirmationDialog
            }
            
            if showLanguageDialog {
                languageDialog
            }
        }
        .onReceive(viewModel.didLogout) {
            // TODO
        }
    }
    
    var userView: some View {
        let user = viewModel.user!
        
        return HStack(spacing: 8) {
            AvatarView(avatarId: user.avatarId, isSelected: false)
                .frame(height: 64)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .fontStyle(theme.typography.heading3)
                
                Text(user.email)
                    .fontStyle(theme.typography.largeLabel)
            }
        }
    }
    
    var accountSettings: some View {
        VStack(spacing: 8) {
            Text("Account Settings")
                .fontStyle(theme.typography.largeLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsButton(text: "Change name") {
                    router.push(.newName)
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                SettingsButton(text: "Change password") {
                    router.push(.newPassword)
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                SettingsButton(text: "Reset progress") {
                    showResetProgressDialog = true
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                DestructiveSettingsButton(text: "Delete account") {
                    showDeleteAccountDialog = true
                }
                .disabled(viewModel.isBusy)
            }
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var applicationSettings: some View {
        let aiModel = switch viewModel.aiModel {
            case .embedded: "On device"
            case .openAI: "OpenAI"
        }
        
        let localeName = appSettings.locale.localizedString(forLanguageCode: appSettings.locale.language.languageCode!.identifier)!
        let uppercasedLocale = localeName.first!.uppercased() + localeName.dropFirst()
        
        return VStack(spacing: 8) {
            Text("App Settings")
                .fontStyle(theme.typography.largeLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsPickerButton(text: "AI model", value: aiModel) {
                    router.push(.chooseAIModel)
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                SettingsPickerButton(text: "Language", value: uppercasedLocale) {
                    showLanguageDialog = true
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                SettingsPickerButton(text: "Notifications", value: "Disabled") {
                    
                }
                .disabled(viewModel.isBusy)
            }
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var about: some View {
        VStack(spacing: 8) {
            Text("About")
                .fontStyle(theme.typography.largeLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsButton(text: "Licenses & Credits") {
                    router.push(.credits)
                }
                .disabled(viewModel.isBusy)
            
                SnapdexHorizontalDivider()
            
                SettingsButton(text: "Privacy policy") {
                    router.push(.privacyPolicy)
                }
                .disabled(viewModel.isBusy)
            }
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var logout: some View {
        DestructiveSettingsButton(text: "Log out") {
            Task {
                await viewModel.logout()
            }
        }
        .disabled(viewModel.isBusy)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var callToAction: some View {
        Text("Snapdex is open-source on [GitHub](https://github.com/TimLariviere/Snapdex-SwiftUI)\nGet in touch at: [timothelariviere.com](https://timothelariviere.com)")
            .fontStyle(theme.typography.smallLabel)
            .tint(theme.colors.primary)
            .multilineTextAlignment(.center)
    }
    
    var resetProgressDialog: some View {
        SnapdexPopup(
            title: "Progress reset",
            description: "This will reset your progression by deleting all the pokemons you caught, and all your sighting pictures. Are you sure you want to continue?",
            primaryButton: PopupButton(text: "Cancel") {
                showResetProgressDialog = false
            },
            secondaryButton: PopupButton(text: "Reset") {
                showDeleteAccountDialog = false
                Task {
                    await viewModel.resetProgress()
                }
            },
            onDismiss: {
                showResetProgressDialog = false
            }
        )
    }
    
    var accountDeletionConfirmationDialog: some View {
        SnapdexPopup(
            title: "Account deletion",
            description: "You are about to permanently delete your account with all associated data. Are you sure you want to continue?",
            primaryButton: PopupButton(text: "Cancel") {
                showDeleteAccountDialog = false
            },
            secondaryButton: PopupButton(text: "Delete") {
                showDeleteAccountDialog = false
                Task {
                    await viewModel.deleteAccount()
                }
            },
            onDismiss: {
                showDeleteAccountDialog = false
            }
        )
    }
    
    var languageDialog: some View {
        SnapdexDialogPicker(
            title: "Set language",
            buttonText: "Choose",
            items: [ Locale(identifier: "en"), Locale(identifier: "fr") ],
            initialItemSelected: appSettings.locale,
            onItemSelected: {
                showLanguageDialog = false
                appSettings.setLocale(locale: $0)
            },
            onDismiss: {
                showLanguageDialog = false
            }
        ) { language in
            let localeName = language.localizedString(forLanguageCode: language.language.languageCode!.identifier)!
            let uppercasedLocale = localeName.first!.uppercased() + localeName.dropFirst()
            return Text(uppercasedLocale)
                .foregroundStyle(theme.colors.onSurface)
        }
    }
}

#Preview {
    AppTheme {
        ProfileScreen(deps: MockAppDependencies.shared)
            .environment(NavBarVisibility())
    }
}
