import FirebaseFirestore

public struct UserRemoteEntity: Codable, @unchecked Sendable {
    @DocumentID public var id: String?
    public let avatarId: Int
    public let name: String
    public let createdAt: UInt64
    public let updatedAt: UInt64
    
    public init(id: String? = nil, avatarId: Int, name: String, createdAt: UInt64, updatedAt: UInt64) {
        self.id = id
        self.avatarId = avatarId
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
