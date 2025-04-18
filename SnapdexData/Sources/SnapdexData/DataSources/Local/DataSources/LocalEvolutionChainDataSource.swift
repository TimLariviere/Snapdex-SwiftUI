class LocalEvolutionChainDataSource {
    private let database: SnapdexDatabase
    
    init(database: SnapdexDatabase) {
        self.database = database
    }
    
    func getFor(pokemonId: String) async -> Result<EvolutionChainWithRelations?, Error> {
        do {
            let entity = try await database.dbQueue.read { db in
                try EvolutionChainEntity
                    .including(
                        all: EvolutionChainEntity.links
                            .including(
                                required: EvolutionChainLinkEntity.pokemon
                                    .including(all: PokemonEntity.translations)
                                    .including(all: PokemonEntity.types)
                                    .including(required: PokemonEntity.ability.including(all: AbilityEntity.translations))
                                    .including(required: PokemonEntity.category.including(all: CategoryEntity.translations))
                            )
                    )
                    .filter(sql: """
                        id IN (
                            SELECT ec.id 
                            FROM EvolutionChains ec
                            LEFT OUTER JOIN EvolutionChainLinks ecl ON ecl.evolutionChainId = ec.id
                            WHERE ec.startingPokemonId = ? OR ecl.pokemonId = ?
                        )
                    """, arguments: [pokemonId, pokemonId])
                    .asRequest(of: EvolutionChainWithRelations.self)
                    .fetchOne(db)
            }
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
}
