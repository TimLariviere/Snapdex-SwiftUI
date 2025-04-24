import Combine
import GRDB
import SnapdexDomain

public final class StatisticDataSource : LocalStatisticsDataSource {
    private let database: SnapdexDatabase
    
    init(database: SnapdexDatabase) {
        self.database = database
    }
    
    public func getCompletionRate(userId: UserId) -> AnyPublisher<Statistic, Error> {
        let observation = ValueObservation.tracking { db in
            let sql = """
                SELECT
                    (SELECT COUNT(*) FROM Pokemons) AS totalPokemonCount,
                    COUNT(DISTINCT up.pokemonId) AS caughtPokemonCount
                FROM
                    UserPokemons up
                WHERE
                    up.userId = ?
            """
            
            return try CompletionRate.fetchOne(db, sql: sql, arguments: [userId])
                ?? CompletionRate(totalPokemonCount: 0, caughtPokemonCount: 0)
        }
        
        return observation.publisher(in: database.dbQueue)
            .map { Statistic(totalPokemonCount: $0.totalPokemonCount, caughtPokemonCount: $0.caughtPokemonCount) }
            .eraseToAnyPublisher()
    }
    
    public func getCompletionRateByType(userId: UserId) -> AnyPublisher<[StatisticByType], Error> {
        let observation = ValueObservation.tracking { db in
            let sql = """
                WITH TypeCounts AS (
                    SELECT 
                        pt.type,
                        COUNT(DISTINCT p.id) AS totalPokemonCount,
                        COUNT(DISTINCT up.pokemonId) AS caughtPokemonCount
                    FROM 
                        PokemonTypes pt
                    JOIN 
                        Pokemons p ON pt.pokemonId = p.id
                    LEFT JOIN 
                        UserPokemons up ON p.id = up.pokemonId AND up.userId = ?
                    GROUP BY 
                        pt.type
                )
                
                SELECT 
                    type,
                    totalPokemonCount,
                    COALESCE(caughtPokemonCount, 0) AS caughtPokemonCount
                FROM 
                    TypeCounts
            """
            
            return try CompletionRateByType.fetchAll(db, sql: sql, arguments: [userId])
        }
        
        return observation.publisher(in: database.dbQueue)
            .map { types in
                types.map {
                    StatisticByType(
                        type: PokemonType.fromInt(value: $0.type),
                        statistic: Statistic(totalPokemonCount: $0.totalPokemonCount, caughtPokemonCount: $0.caughtPokemonCount)
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
