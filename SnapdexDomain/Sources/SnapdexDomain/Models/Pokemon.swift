import Foundation

public struct Pokemon : Sendable, Equatable {
    public let id: PokemonId
    public let name: [Locale: String]
    public let description: [Locale: String]
    public let types: [PokemonType]
    public let weaknesses: [PokemonType]
    public let weight: Measurement<UnitMass>
    public let height: Measurement<UnitLength>
    public let category: PokemonCategory
    public let ability: PokemonAbility
    public let maleToFemaleRatio: Double
    
    public init(id: PokemonId, name: [Locale : String], description: [Locale : String], types: [PokemonType], weaknesses: [PokemonType], weight: Measurement<UnitMass>, height: Measurement<UnitLength>, category: PokemonCategory, ability: PokemonAbility, maleToFemaleRatio: Double) {
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
