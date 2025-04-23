import Combine
import Foundation
import SnapdexDomain

public enum GetPokemonByIdError : Error {
    case getFailed
}

public enum CatchPokemonError : Error {
    case catchFailed
}

public enum ResetForUserError : Error {
    case resetFailed
}

public protocol PokemonServicing : Sendable {
    func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Error>
    func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError>
    func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError>
    func resetForUser(userId: UserId) async -> Result<Void, ResetForUserError>
}

public final class PokemonService : PokemonServicing {
    private let crashReporter: CrashReporter
    private let localUserPokemons: LocalUserPokemonDataSource
    private let localPokemons: LocalPokemonDataSource
    
    public init(crashReporter: CrashReporter, localUserPokemons: LocalUserPokemonDataSource, localPokemons: LocalPokemonDataSource) {
        self.crashReporter = crashReporter
        self.localUserPokemons = localUserPokemons
        self.localPokemons = localPokemons
    }
    
    public func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Error> {
        return localUserPokemons.observeAllForUser(userId: userId)
    }
    
    public func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError> {
        do {
            let pokemon = try await localPokemons.getById(pokemonId: pokemonId)
            return .success(pokemon)
        } catch {
            crashReporter.recordException(error: error, metadata: ["pokemonId": pokemonId.description])
            return .failure(.getFailed)
        }
    }
    
    public func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError> {
        do {
            let timestamp: UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
            
            if (try await localUserPokemons.exists(userId: userId, pokemonId: pokemonId)) {
                return .success(())
            }
            
            let value = Synced(value: pokemonId, createdAt: timestamp, updatedAt: timestamp)
            try await localUserPokemons.upsert(userId: userId, pokemon: value)
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: ["userId": userId, "pokemonId": pokemonId.description])
            return .failure(.catchFailed)
        }
    }
    
    public func resetForUser(userId: UserId) async -> Result<Void, ResetForUserError> {
        do {
            try await localUserPokemons.deleteAllForUser(userId: userId)
            
            // TODO
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: ["userId": userId])
            return .failure(.resetFailed)
        }
    }
}
