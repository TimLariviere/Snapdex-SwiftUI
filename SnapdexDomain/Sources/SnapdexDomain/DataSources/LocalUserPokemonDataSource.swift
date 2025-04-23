import Combine

public protocol LocalUserPokemonDataSource : Sendable {
    func observeAllForUser(userId: UserId) -> AnyPublisher<[Pokemon], Error>
    func getAllForUser(userId: UserId) async throws -> [Synced<PokemonId>]
    func upsert(userId: UserId, pokemon: Synced<PokemonId>) async throws
    func upsertAll(userId: UserId, pokemons: [Synced<PokemonId>]) async throws
    func deleteAllForUser(userId: UserId) async throws
    func exists(userId: UserId, pokemonId: PokemonId) async throws -> Bool
}
