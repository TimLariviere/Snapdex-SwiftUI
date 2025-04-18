import GRDB

class LocalUserPokemonDataSource {
    private let database: SnapdexDatabase
    
    init(database: SnapdexDatabase) {
        self.database = database
    }
    
    func upsert(entity: UserPokemonEntity) async -> Result<Void, Error> {
        do {
            try await database.dbQueue.write { db in
                var entity = entity
                try entity.insert(db, onConflict: .replace)
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func insertAll(pokemons: [UserPokemonEntity]) async -> Result<Void, Error> {
        do {
            try await database.dbQueue.write { db in
                try pokemons.forEach {
                    var pokemon = $0
                    try pokemon.insert(db, onConflict: .replace)
                }
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func exists(userId: String, pokemonId: Int) async -> Result<Bool, Error> {
        do {
            let count = try await database.dbQueue.read { db in
                try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId && UserPokemonEntity.Columns.pokemonId == pokemonId).fetchCount(db)
            }
            return .success(count > 0)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAllForUser(userId: String) async -> Result<Void, Error> {
        do {
            let _ = try await database.dbQueue.write { db in
                try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId).deleteAll(db)
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func getAllForUser(userId: String) async -> Result<[UserPokemonEntity], Error> {
        do {
            let entities = try await database.dbQueue.read { db in
                try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId).fetchAll(db)
            }
            return .success(entities)
        } catch {
            return .failure(error)
        }
    }
    
    func observeUserPokemons(userId: String) -> DatabasePublishers.Value<[PokemonWithRelations]> {
        let observation = ValueObservation.tracking { db in
            try PokemonEntity
                .including(all: PokemonEntity.translations)
                .including(all: PokemonEntity.types)
                .including(required: PokemonEntity.ability.including(all: AbilityEntity.translations))
                .including(required: PokemonEntity.category.including(all: CategoryEntity.translations))
                .filter(sql: """
                id IN (
                    SELECT pokemonId FROM UserPokemons
                    WHERE userId = ?
                )
            """, arguments: [userId])
                .asRequest(of: PokemonWithRelations.self)
                .fetchAll(db)
        }
        
        return observation.publisher(in: database.dbQueue)
    }
}
