public protocol LocalPokemonDataSource : Sendable {
    func getById(pokemonId: PokemonId) async throws -> Pokemon?
}
