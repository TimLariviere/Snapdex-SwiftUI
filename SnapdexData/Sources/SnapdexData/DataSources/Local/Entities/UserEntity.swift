import GRDB

public struct UserEntity: Codable, FetchableRecord, PersistableRecord, Identifiable, Sendable {
    public var id: String
    public var avatarId: Int
    public var name: String
    public var email: String
    public var createdAt: UInt64
    public var updatedAt: UInt64
    
    public static let databaseTableName: String = "Users"
}

public struct UserPokemonEntity: Codable, FetchableRecord, MutablePersistableRecord, Identifiable, Sendable {
    public var id: Int?
    public var userId: String
    public var pokemonId: Int
    public var createdAt: UInt64
    public var updatedAt: UInt64
     
    public static let databaseTableName: String = "UserPokemons"
    
    mutating func didInsert(with rowID: Int, for column: String?) {
        self.id = rowID
    }
    
    enum Columns: String, ColumnExpression {
        case userId
        case pokemonId
    }
}
