import SwiftUI
import Combine
import SnapdexDesignSystem
import SnapdexDomain
import SnapdexUseCases

enum StatsTabDestination: Hashable {
    
}

public struct StatsTabCoordinator: View {
    @State private var router = Router<StatsTabDestination>()
    
    private let deps: AppDependencies
    
    public init(deps: AppDependencies) {
        self.deps = deps
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            StatsScreen(
                deps: deps
            )
        }
        .environment(router)
    }
}

#Preview {
    AppTheme {
        StatsTabCoordinator(
            deps: MockAppDependencies.shared
        )
    }
}
