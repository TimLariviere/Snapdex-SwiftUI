import Combine

enum CatchPokemonError: Error {
    case catchFailed
}

protocol PokemonRepository {
    func observePokemonsCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Error>
    func getPokemonById(pokemonId: PokemonId) async -> Pokemon?
    func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError>
    func resetForUser(userId: UserId) async
}
