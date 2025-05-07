import SwiftUI
import SnapdexDomain

public extension PokemonWithRelations {
    func toPokemon() -> Pokemon {
        let types = types.map { PokemonType.fromInt(value: $0.type) }
        
        return Pokemon(
            id: self.pokemon.id,
            name: translations.associate { (Locale(identifier: $0.language), $0.name) },
            description: translations.associate { (Locale(identifier: $0.language), $0.description) },
            types: types,
            weaknesses: PokemonWeaknessCalculator.calculateWeaknesses(types: types),
            weight: Measurement(value: pokemon.weight, unit: .hectograms),
            height: Measurement(value: pokemon.height, unit: .decimeters),
            category: PokemonCategory(id: category.category.id, name: category.translations.associate { (Locale(identifier: $0.language), $0.name) }),
            ability: PokemonAbility(id: ability.ability.id, name: ability.translations.associate { (Locale(identifier: $0.language), $0.name) }),
            maleToFemaleRatio: pokemon.maleToFemaleRatio
        )
    }
}
