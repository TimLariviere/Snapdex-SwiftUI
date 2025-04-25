import SnapdexDomain

public final class PokemonDataSource: LocalPokemonDataSource {
    private let database: SnapdexDatabase
    
    public init(database: SnapdexDatabase) {
        self.database = database
    }
    
    public func getById(pokemonId: PokemonId) async throws -> Pokemon? {
        let entity = try await database.dbQueue.read { db in
            try PokemonEntity
                .including(all: PokemonEntity.translations)
                .including(all: PokemonEntity.types)
                .including(required: PokemonEntity.ability.including(all: AbilityEntity.translations))
                .including(required: PokemonEntity.category.including(all: CategoryEntity.translations))
                .asRequest(of: PokemonWithRelations.self)
                .filter(key: pokemonId)
                .fetchOne(db)
        }
        return entity?.toPokemon()
    }
}
