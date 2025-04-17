import FirebaseFirestore

struct UserRemoteEntity: Codable, @unchecked Sendable {
    @DocumentID var id: String?
    let avatarId: Int
    let name: String
    let createdAt: UInt64
    let updatedAt: UInt64
}
