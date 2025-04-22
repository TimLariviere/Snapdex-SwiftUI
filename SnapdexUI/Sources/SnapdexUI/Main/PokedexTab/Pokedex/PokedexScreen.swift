import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

public struct PokedexScreen: View {
    @State private var search: String = ""
    
    public init() {}
    
    public var body: some View {
        SnapdexScaffold {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    SearchView(text: $search, hint: "Search Pokémon...")
                        .padding(.horizontal, 16)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                            ForEach(0..<151, id: \.self) { index in
                                if (index == 0) {
                                    PokemonItem(
                                        pokemon: Pokemon(
                                            id: 1,
                                            name: [ Locale(identifier: "en") : "Charizard" ],
                                            description: [ Locale(identifier: "en") : "Charizard" ],
                                            types: [ .fire ],
                                            weaknesses: [ .water ],
                                            weight: .kilograms,
                                            height: .meters,
                                            category: PokemonCategory(id: 0, name: [ Locale(identifier: "en") : "Charizard" ]),
                                            ability: PokemonAbility(id: 0, name: [ Locale(identifier: "en") : "Charizard" ]),
                                            maleToFemaleRatio: 0.9
                                        )
                                    )
                                    .aspectRatio(4.0/5.0, contentMode: .fit)
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
    }
}
