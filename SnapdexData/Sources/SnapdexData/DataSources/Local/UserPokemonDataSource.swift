import Combine
import GRDB
import SnapdexDomain

public final class UserPokemonDataSource : LocalUserPokemonDataSource {
    private let database: SnapdexDatabase
    
    public init(database: SnapdexDatabase) {
        self.database = database
    }
    
    public func observeAllForUser(userId: UserId) -> AnyPublisher<[Pokemon], Error> {
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
            .map { pokemons in pokemons.map { $0.toPokemon() } }
            .eraseToAnyPublisher()
    }
    
    public func getAllForUser(userId: UserId) async throws -> [Synced<PokemonId>] {
        let entities = try await database.dbQueue.read { db in
            try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId).fetchAll(db)
        }
        
        return entities.map { $0.toSyncedPokemon() }
    }
    
    public func upsert(userId: UserId, pokemon: Synced<PokemonId>) async throws {
        let entity = pokemon.toUserPokemonEntity(userId: userId)
        try await database.dbQueue.write { db in
            var mutatingEntity = entity
            try mutatingEntity.insert(db, onConflict: .replace)
        }
    }
    
    public func upsertAll(userId: UserId, pokemons: [Synced<PokemonId>]) async throws {
        try await database.dbQueue.write { db in
            try pokemons.forEach {
                var pokemon = $0.toUserPokemonEntity(userId: userId)
                try pokemon.insert(db, onConflict: .replace)
            }
        }
    }
    
    public func deleteAllForUser(userId: UserId) async throws {
        let _ = try await database.dbQueue.write { db in
            try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId).deleteAll(db)
        }
    }
    
    public func exists(userId: UserId, pokemonId: PokemonId) async throws -> Bool {
        let count = try await database.dbQueue.read { db in
            try UserPokemonEntity.filter(UserPokemonEntity.Columns.userId == userId && UserPokemonEntity.Columns.pokemonId == pokemonId).fetchCount(db)
        }
        return count > 0
    }
}
