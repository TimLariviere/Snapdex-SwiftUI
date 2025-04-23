import SnapdexDomain

public extension UserPokemonRemoteEntity {
    func toSyncedPokemon() -> Synced<PokemonId> {
        return Synced(value: pokemonId, createdAt: createdAt, updatedAt: updatedAt)
    }
}

public extension Synced where T == PokemonId {
    func toUserRemotePokemonEntity(userId: UserId) -> UserPokemonRemoteEntity {
        return UserPokemonRemoteEntity(userId: userId, pokemonId: value, createdAt: createdAt, updatedAt: updatedAt)
    }
}
