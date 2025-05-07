import SwiftUI
import Combine
import SnapdexDesignSystem
import SnapdexDomain
import SnapdexUseCases

enum ProfileTabDestination: Hashable {
    case newName
    case newPassword
    case chooseAIModel
    case credits
    case privacyPolicy
}

public struct ProfileTabCoordinator: View {
    @State private var router = Router<ProfileTabDestination>()
    
    private let deps: AppDependencies
    
    public init(deps: AppDependencies) {
        self.deps = deps
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            ProfileScreen(
                deps: deps
            )
        }
        .environment(router)
    }
}
