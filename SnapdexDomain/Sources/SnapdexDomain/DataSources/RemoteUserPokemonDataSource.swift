public enum GetAllForRemoteUserError : Error {
    case failure(Error)
    case networkError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum UpsertRemoteUserPokemonError : Error {
    case failure(Error)
    case networkError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public enum DeleteAllForRemoteUserError : Error {
    case failure(Error)
    case networkError
    
    public var isNetworkError: Bool {
        if case .networkError = self { return true }
        return false
    }
}

public protocol RemoteUserPokemonDataSource : Sendable {
    func getAllForUser(userId: UserId) async -> Result<[Synced<PokemonId>], GetAllForRemoteUserError>
    func upsert(userId: UserId, pokemon: Synced<PokemonId>) async -> Result<Void, UpsertRemoteUserPokemonError>
    func deleteAllForUser(userId: UserId) async -> Result<Void, DeleteAllForRemoteUserError>
}
