import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain
import SnapdexUseCases

enum PokedexTabDestination: Hashable {
    case pokemonDetail(PokemonId)
}

public struct PokedexTabCoordinator: View {
    @State private var router = Router<PokedexTabDestination>()
    
    let deps: AppDependencies
    
    public init(deps: AppDependencies) {
        self.deps = deps
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            PokedexScreen(
                //deps: deps,
            )
                .navigationDestination(for: PokedexTabDestination.self) { destination in
                    switch destination {
                        case .pokemonDetail(let pokemonId): PokemonDetailScreen(
                            deps: deps,
                            pokemonId: pokemonId
                        )
                    }
                }
                .environment(router)
        }
    }
}

#Preview {
    AppTheme {
        PokedexTabCoordinator(
            deps: MockAppDependencies.shared
        )
    }
}
