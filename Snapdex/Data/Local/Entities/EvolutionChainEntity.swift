import GRDB

struct EvolutionChainEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var startingPokemonId: Int
    
    static let databaseTableName: String = "EvolutionChains"
    
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
    
    enum Columns: String, ColumnExpression {
        case evolutionChainId
    }
}
