class LocalPokemonDataSource {
    private let database: SnapdexDatabase
    
    init(database: SnapdexDatabase) {
        self.database = database
    }
    
    func getAll() async -> Result<[PokemonWithRelations], Error> {
        do {
            let entities = try await database.dbQueue.read { db in
                try PokemonEntity
                    .including(all: PokemonEntity.translations)
                    .including(all: PokemonEntity.types)
                    .including(required: PokemonEntity.ability.including(all: AbilityEntity.translations))
                    .including(required: PokemonEntity.category.including(all: CategoryEntity.translations))
                    .asRequest(of: PokemonWithRelations.self)
                    .fetchAll(db)
            }
            return .success(entities)
        } catch {
            return .failure(error)
        }
    }
    
    func getBy(id: Int) async -> Result<PokemonWithRelations?, Error> {
        do {
            let entity = try await database.dbQueue.read { db in
                try PokemonEntity
                    .including(all: PokemonEntity.translations)
                    .including(all: PokemonEntity.types)
                    .including(required: PokemonEntity.ability.including(all: AbilityEntity.translations))
                    .including(required: PokemonEntity.category.including(all: CategoryEntity.translations))
                    .asRequest(of: PokemonWithRelations.self)
                    .fetchOne(db)
            }
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
}
