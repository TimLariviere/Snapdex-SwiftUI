import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct PokedexScreen: View {
    @Environment(Router<PokedexTabDestination>.self) private var router
    @State private var search: String = ""
    
    var body: some View {
        SnapdexScaffold {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    SearchView(text: $search, hint: "Search Pokémon...")
                        .padding(.horizontal, 16)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                            ForEach(0..<151, id: \.self) { index in
                                if (index == 0) {
                                    let pokemon = Pokemon(
                                        id: 1,
                                        name: [ Locale(identifier: "en") : "Charizard" ],
                                        description: [ Locale(identifier: "en") : "Charizard" ],
                                        types: [ .fire ],
                                        weaknesses: [ .water ],
                                        weight: Measurement(value: 100, unit: .kilograms),
                                        height: Measurement(value: 1.7, unit: .meters),
                                        category: PokemonCategory(id: 0, name: [ Locale(identifier: "en") : "Lizard" ]),
                                        ability: PokemonAbility(id: 0, name: [ Locale(identifier: "en") : "Blaze" ]),
                                        maleToFemaleRatio: 0.9
                                    )
                                    
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
                        .padding(.horizontal, 16)
                        .padding(.bottom, 64)
                    }
                }
                
                SnapdexFloatingActionButton {
                    
                }
                .padding(.bottom, 64)
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    AppTheme {
        PokedexScreen()
            .environment(Router<PokedexTabDestination>())
    }
}
