import SwiftUI
import SnapdexDesignSystem

struct MainScreen: View {
    @State private var selectedTab = 0
    
    let deps: AppDependencies
    
    public init(deps: AppDependencies) {
        self.deps = deps
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PokedexTabCoordinator(deps: deps)
                .opacity(selectedTab == 0 ? 1.0 : 0.0)
            
            Text("Stats")
                .opacity(selectedTab == 1 ? 1.0 : 0.0)
            
            Text("Profile")
                .opacity(selectedTab == 2 ? 1.0 : 0.0)
            
            SnapdexNavBar(
                tabs: [
                    TabItem(selected: .gridSelected, unselected: .gridUnselected),
                    TabItem(selected: .statsSelected, unselected: .statsUnselected),
                    TabItem(selected: .profileSelected, unselected: .profileUnselected)
                ],
                selected: $selectedTab
            )
        }
    }
}
