public protocol LocalEvolutionChainDataSource : Sendable {
    func getForPokemon(pokemonId: PokemonId) async throws -> EvolutionChain?
}
