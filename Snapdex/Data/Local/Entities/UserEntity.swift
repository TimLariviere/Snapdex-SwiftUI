import GRDB

struct UserEntity: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: String
    var avatarId: Int
    var name: String
    var email: String
    var createdAt: UInt64
    var updatedAt: UInt64
    
    static let databaseTableName: String = "Users"
}

struct UserPokemonEntity: Codable, FetchableRecord, MutablePersistableRecord, Identifiable {
    var id: Int
    var userId: String
    var pokemonId: Int
    var createdAt: UInt64
    var updatedAt: UInt64
    
    static let databaseTableName: String = "UserPokemons"
    
    enum Columns: String, ColumnExpression {
        case userId
        case pokemonId
    }
}
