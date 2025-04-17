import Foundation

struct Pokemon {
    let id: PokemonId
    let name: [Locale: String]
    let description: [Locale: String]
    let types: [PokemonType]
    let weaknesses: [PokemonType]
    let weight: UnitMass
    let height: UnitLength
    let category: PokemonCategory
    let ability: PokemonAbility
    let maleToFemaleRatio: Float
}
