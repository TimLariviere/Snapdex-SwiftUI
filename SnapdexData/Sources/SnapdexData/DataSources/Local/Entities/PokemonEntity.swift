import GRDB

public struct PokemonEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    public var weight: Double
    public var height: Double
    public var categoryId: Int
    public var abilityId: Int
    public var maleToFemaleRatio: Double
    
    public static let databaseTableName: String = "Pokemons"
    public static let translations = hasMany(PokemonTranslationEntity.self)
    public static let types = hasMany(PokemonTypeEntity.self)
    public static let ability = belongsTo(AbilityEntity.self, using: ForeignKey(["abilityId"]))
    public static let category = belongsTo(CategoryEntity.self, using: ForeignKey(["categoryId"]))
    
    enum Columns: String, ColumnExpression {
        case categoryId
        case abilityId
    }
}

public struct PokemonTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    public var pokemonId: Int
    public var language: String
    public var name: String
    public var description: String
    
    public static let databaseTableName: String = "PokemonTranslations"
    
    enum Columns: String, ColumnExpression {
        case pokemonId
    }
}

public struct PokemonTypeEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    public var pokemonId: Int
    public var type: Int
    
    public static let databaseTableName: String = "PokemonTypes"
    
    enum Columns: String, ColumnExpression {
        case pokemonId
    }
}
