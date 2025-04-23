import SnapdexDomain

public extension Synced where T == PokemonId {
    func toUserPokemonEntity(userId: String) -> UserPokemonEntity {
        return UserPokemonEntity(userId: userId, pokemonId: value, createdAt: createdAt, updatedAt: updatedAt)
    }
}

public extension UserPokemonEntity {
    func toSyncedPokemon() -> Synced<PokemonId> {
        return Synced(value: pokemonId, createdAt: createdAt, updatedAt: updatedAt)
    }
}
