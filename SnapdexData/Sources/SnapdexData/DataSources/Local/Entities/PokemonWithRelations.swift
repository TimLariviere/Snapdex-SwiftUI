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


extension PokemonWithRelations {
    public init(row: Row) {        
        pokemon = try! PokemonEntity(row: row)
        translations = row.prefetchedRows["PokemonTranslations"]!.map { try! PokemonTranslationEntity(row: $0) }
        types = row.prefetchedRows["PokemonTypes"]!.map { try! PokemonTypeEntity(row: $0) }
        ability = AbilityWithTranslation(row: row)
        category = CategoryWithTranslation(row: row)
    }
}

extension AbilityWithTranslation {
    public init(row: Row) {
        ability = try! AbilityEntity(row: row)
        translations = row.prefetchedRows["AbilityTranslations"]!.map { try! AbilityTranslationEntity(row: $0) }
    }
}

extension CategoryWithTranslation {
    public init(row: Row) {
        category = try! CategoryEntity(row: row)
        translations = row.prefetchedRows["CategoryTranslations"]!.map { try! CategoryTranslationEntity(row: $0) }
    }
}
