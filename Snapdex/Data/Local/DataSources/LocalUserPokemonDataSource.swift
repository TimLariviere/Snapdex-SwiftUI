class LocalUserPokemonDataSource {
    func insertAll(pokemons: [UserPokemonEntity]) async -> Result<Void, Error> {
        return .success(())
    }
}
