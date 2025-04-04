import SwiftUI

enum MainNavigationPath {
    case pokedexTab
    case statsTab
    case profileTab
}

struct MainNavigation: View {
    @Environment(\.theme) private var theme
    @State private var path: [MainNavigationPath] = []
    
    private let container: Container
    private let onLoggedOut: () -> Void
    
    init(container: Container, onLoggedOut: @escaping () -> Void) {
        self.container = container
        self.onLoggedOut = onLoggedOut
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Text("Main")
        }
    }
}
