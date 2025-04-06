import GRDB

struct PokemonWithRelations: Decodable, FetchableRecord {
    var pokemon: PokemonEntity
    var translations: [PokemonTranslationEntity]
    var types: [PokemonTypeEntity]
    var ability: AbilityWithTranslation
    var category: CategoryWithTranslation
}

struct AbilityWithTranslation: Decodable, FetchableRecord {
    var ability: AbilityEntity
    var translations: [AbilityTranslationEntity]
}

struct CategoryWithTranslation: Decodable, FetchableRecord {
    var category: CategoryEntity
    var translations: [CategoryTranslationEntity]
}
