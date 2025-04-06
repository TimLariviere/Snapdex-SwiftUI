import GRDB

struct EvolutionChainEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var startingPokemonId: Int
    
    static let databaseTableName: String = "EvolutionChains"
    static let links = hasMany(EvolutionChainLinkEntity.self)
    
    enum Columns: String, ColumnExpression {
        case startingPokemonId
    }
}

struct EvolutionChainLinkEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var evolutionChainId: Int
    var pokemonId: Int
    var minLevel: Int
    
    static let databaseTableName: String = "EvolutionChainLinks"
    static let pokemon = belongsTo(PokemonEntity.self)
    
    enum Columns: String, ColumnExpression {
        case evolutionChainId
    }
}
