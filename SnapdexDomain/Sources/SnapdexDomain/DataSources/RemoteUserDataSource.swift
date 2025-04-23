public enum GetRemoteUserError : Error {
    case failure(Error)
    case networkError
}

public enum UpsertRemoteUserError : Error {
    case failure(Error)
    case networkError
}

public enum DeleteRemoteUserError : Error {
    case failure(Error)
    case networkError
}

public protocol RemoteUserDataSource : Sendable {
    func getById(userId: UserId) async -> Result<Synced<User>?, GetRemoteUserError>
    func upsert(user: Synced<User>) async -> Result<Void, UpsertRemoteUserError>
    func delete(userId: UserId) async -> Result<Void, DeleteRemoteUserError>
}
