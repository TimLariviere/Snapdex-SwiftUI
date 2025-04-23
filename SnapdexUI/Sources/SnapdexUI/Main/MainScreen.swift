import SwiftUI
import SnapdexDesignSystem

@Observable class NavBarVisibility {
    var isVisible: Bool = true
}


struct MainScreen: View {
    @State private var selectedTab = 0
    @State private var navBarVisibility = NavBarVisibility()
    
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
            .offset(y: navBarVisibility.isVisible ? 0 : 100)
            .opacity(navBarVisibility.isVisible ? 1 : 0)
            .animation(
                navBarVisibility.isVisible ? .easeOut(duration: 0.3) : .easeIn(duration: 0.3),
                value: navBarVisibility.isVisible
            )
        }
        .environment(navBarVisibility)
    }
}
