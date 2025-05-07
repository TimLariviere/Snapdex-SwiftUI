import SwiftUI
import SnapdexDesignSystem

struct NewNameScreen: View {
    @Environment(Router<ProfileTabDestination>.self) private var router
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @State private var viewModel: NewNameViewModel
    @State private var showNameChangedPopup: Bool = false
    
    init(deps: AppDependencies) {
        self._viewModel = State(initialValue: NewNameViewModel(deps: deps))
    }
    
    var body: some View {
        SnapdexScaffold(title: "New name") {
            VStack(spacing: 8) {
                SnapdexTextField(text: $viewModel.name, hint: "New name")
                
                Spacer()
                
                SnapdexPrimaryButton("Set new name", enabled: viewModel.canChangeName, isBusy: viewModel.isChangingName) {
                    Task {
                        await viewModel.setName()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .overlay {
            if showNameChangedPopup {
                nameChangedPopup
            }
        }
        .onReceive(viewModel.didChangeName) {
            showNameChangedPopup = true
        }
        .onAppear {
            navBarVisibility.isVisible = false
        }
    }
    
    var nameChangedPopup: some View {
        SnapdexPopup(
            title: "Name Changed",
            description: "Your name has been changed.",
            onDismiss: {
                showNameChangedPopup = false
                router.pop()
            },
            primaryButton: PopupButton(text: "OK") {
                showNameChangedPopup = false
                router.pop()
            }
        )
    }
}
