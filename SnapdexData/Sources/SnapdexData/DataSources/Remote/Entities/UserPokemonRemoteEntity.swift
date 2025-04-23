import FirebaseFirestore

public struct UserPokemonRemoteEntity: Codable {
    @DocumentID public var id: String?
    public let userId: String
    public let pokemonId: Int
    public let createdAt: UInt64
    public let updatedAt: UInt64
    
    public init(id: String? = nil, userId: String, pokemonId: Int, createdAt: UInt64, updatedAt: UInt64) {
        self.id = id
        self.userId = userId
        self.pokemonId = pokemonId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
