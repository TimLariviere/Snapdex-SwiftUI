import SwiftUI
import SnapdexDomain

@Observable class PokemonDetailViewModel {
    private let pokemonId: PokemonId
    var pokemon: Pokemon? = nil
    
    init(deps: AppDependencies, pokemonId: PokemonId) {
        // todo: inject dependencies
        self.pokemonId = pokemonId
    }
    
    func loadPokemon() {
        pokemon = Pokemon(
            id: 6,
            name: [ Locale(identifier: "en") : "Charizard" ],
            description: [ Locale(identifier: "en") : "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
            types: [ .fire, .flying ],
            weaknesses: [ .bug ],
            weight: Measurement(value: 100, unit: .kilograms),
            height: Measurement(value: 1.7, unit: .meters),
            category: PokemonCategory(id: 0, name: [ Locale(identifier: "en") : "Lizard" ]),
            ability: PokemonAbility(id: 0, name: [ Locale(identifier: "en") : "Blaze" ]),
            maleToFemaleRatio: 0.875
        )
    }
}
