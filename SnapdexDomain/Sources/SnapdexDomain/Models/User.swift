public struct User: Sendable {
    public let id: UserId?
    public let avatarId: AvatarId
    public let name: String
    public let email: String
    
    public init(id: UserId?, avatarId: AvatarId, name: String, email: String) {
        self.id = id
        self.avatarId = avatarId
        self.name = name
        self.email = email
    }
}
