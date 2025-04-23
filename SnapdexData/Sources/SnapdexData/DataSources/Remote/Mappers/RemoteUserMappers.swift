import SnapdexDomain

public extension UserRemoteEntity {
    func toUser() -> User {
        return User(id: id, avatarId: avatarId, name: name, email: "")
    }
    
    func toSyncedUser() -> Synced<User> {
        return Synced(value: toUser(), createdAt: createdAt, updatedAt: updatedAt)
    }
}

public extension Synced where T == User {
    func toUserRemoteEntity() -> UserRemoteEntity {
        return UserRemoteEntity(id: value.id!, avatarId: value.avatarId, name: value.name, createdAt: createdAt, updatedAt: updatedAt)
    }
}
