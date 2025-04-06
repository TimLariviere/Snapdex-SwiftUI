import GRDB

struct PokemonEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var weight: Double
    var height: Double
    var categoryId: Int
    var abilityId: Int
    var maleToFemaleRatio: Double
    
    static let databaseTableName: String = "Pokemons"
    static let translations = hasMany(PokemonTranslationEntity.self)
    static let types = hasMany(PokemonTypeEntity.self)
    static let ability = belongsTo(AbilityEntity.self)
    static let category = belongsTo(CategoryEntity.self)
    
    enum Columns: String, ColumnExpression {
        case categoryId
        case abilityId
    }
}

struct PokemonTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var pokemonId: Int
    var language: String
    var name: String
    var description: String
    
    static let databaseTableName: String = "PokemonTranslations"
    
    enum Columns: String, ColumnExpression {
        case pokemonId
    }
}

struct PokemonTypeEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var pokemonId: Int
    var type: Int
    
    static let databaseTableName: String = "PokemonTypes"
    
    enum Columns: String, ColumnExpression {
        case pokemonId
    }
}
