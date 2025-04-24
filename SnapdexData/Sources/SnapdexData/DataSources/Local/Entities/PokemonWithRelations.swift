import GRDB

public struct PokemonWithRelations: Decodable, FetchableRecord, Sendable {
    public var pokemon: PokemonEntity
    public var translations: [PokemonTranslationEntity]
    public var types: [PokemonTypeEntity]
    public var ability: AbilityWithTranslation
    public var category: CategoryWithTranslation
}

public struct AbilityWithTranslation: Decodable, FetchableRecord, Sendable {
    public var ability: AbilityEntity
    public var translations: [AbilityTranslationEntity]
}

public struct CategoryWithTranslation: Decodable, FetchableRecord, Sendable {
    public var category: CategoryEntity
    public var translations: [CategoryTranslationEntity]
}
