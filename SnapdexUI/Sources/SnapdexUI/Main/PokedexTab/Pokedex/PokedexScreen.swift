import SwiftUI
import Combine
import SnapdexDesignSystem
import SnapdexDomain

struct PokedexScreen: View {
    @Environment(Router<PokedexTabDestination>.self) private var router
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @State private var viewModel: PokedexViewModel
    
    init(deps: AppDependencies) {
        self._viewModel = State(initialValue: PokedexViewModel(deps: deps))
    }
    
    var body: some View {
        SnapdexScaffold {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    SearchView(text: $viewModel.search, hint: "Search Pokémon...")
                        .padding(.horizontal, 16)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                            if let filteredPokemons = viewModel.filteredPokemons {
                                ForEach(filteredPokemons, id: \.id) { pokemon in
                                    PokemonItem(pokemon: pokemon)
                                        .aspectRatio(4.0/5.0, contentMode: .fit)
                                        .onTapGesture {
                                            router.push(.pokemonDetail(pokemon.id))
                                        }
                                }
                            } else {
                                ForEach(0..<151, id: \.self) { index in
                                    let pokemonId = index + 1
                                    let pokemon = viewModel.allPokemons.first { $0.id == pokemonId }
                                    
                                    if let pokemon = pokemon {
                                        PokemonItem(pokemon: pokemon)
                                            .aspectRatio(4.0/5.0, contentMode: .fit)
                                            .onTapGesture {
                                                router.push(.pokemonDetail(pokemon.id))
                                            }
                                    } else {
                                        UnknownItem(id: index + 1)
                                            .aspectRatio(4.0/5.0, contentMode: .fit)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 64)
                    }
                }
                
                SnapdexFloatingActionButton {
                    navBarVisibility.isVisible = false
                    viewModel.startRecognition()
                }
                .padding(.bottom, 64)
                .padding(.horizontal, 16)
            }
        }
        .overlay {
            if let recognitionState = viewModel.recognitionState {
                RecognitionOverlay(state: recognitionState) {
                    viewModel.stopRecognition()
                    navBarVisibility.isVisible = true
                }
            }
        }
        .onAppear {
            navBarVisibility.isVisible = true
        }
    }
}

#Preview {
    AppTheme {
        PokedexScreen(
            deps: MockAppDependencies()
        )
            .environment(Router<PokedexTabDestination>())
            .environment(NavBarVisibility())
    }
}
