import Foundation

public struct Pokemon {
    public let id: PokemonId
    public let name: [Locale: String]
    public let description: [Locale: String]
    public let types: [PokemonType]
    public let weaknesses: [PokemonType]
    public let weight: UnitMass
    public let height: UnitLength
    public let category: PokemonCategory
    public let ability: PokemonAbility
    public let maleToFemaleRatio: Float
    
    public init(id: PokemonId, name: [Locale : String], description: [Locale : String], types: [PokemonType], weaknesses: [PokemonType], weight: UnitMass, height: UnitLength, category: PokemonCategory, ability: PokemonAbility, maleToFemaleRatio: Float) {
        self.id = id
        self.name = name
        self.description = description
        self.types = types
        self.weaknesses = weaknesses
        self.weight = weight
        self.height = height
        self.category = category
        self.ability = ability
        self.maleToFemaleRatio = maleToFemaleRatio
    }
}
