import SnapdexDomain

public extension UserEntity {
    func toUser() -> User {
        User(id: id, avatarId: avatarId, name: name, email: email)
    }
    
    func toSyncedUser() -> Synced<User> {
        Synced(value: toUser(), createdAt: createdAt, updatedAt: updatedAt)
    }
}

public extension Synced where T == User {
    func toUserEntity() -> UserEntity {
        return UserEntity(id: value.id!, avatarId: value.avatarId, name: value.name, email: value.email, createdAt: createdAt, updatedAt: updatedAt)
    }
}
