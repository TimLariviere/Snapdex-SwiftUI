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
    func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Never>
    func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError>
    func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError>
    func resetForUser(userId: UserId) async -> Result<Void, ResetForUserError>
}

public final class PokemonService : PokemonServicing {
    private let crashReporter: CrashReporter
    private let localUserPokemons: LocalUserPokemonDataSource
    private let localPokemons: LocalPokemonDataSource
    private let remoteUserPokemons: RemoteUserPokemonDataSource
    
    public init(crashReporter: CrashReporter, localUserPokemons: LocalUserPokemonDataSource, localPokemons: LocalPokemonDataSource, remoteUserPokemons: RemoteUserPokemonDataSource) {
        self.crashReporter = crashReporter
        self.localUserPokemons = localUserPokemons
        self.localPokemons = localPokemons
        self.remoteUserPokemons = remoteUserPokemons
    }
    
    public func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Never> {
        return localUserPokemons.observeAllForUser(userId: userId)
            .catch { error -> AnyPublisher<[Pokemon], Never> in
                self.crashReporter.recordException(error: error, metadata: ["userId": userId])
                return Just([Pokemon]()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError> {
        do {
            let pokemon = try await localPokemons.getById(pokemonId: pokemonId)
            return .success(pokemon)
        } catch {
            crashReporter.recordException(error: error, metadata: ["pokemonId": String(pokemonId)])
            return .failure(.getFailed)
        }
    }
    
    public func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError> {
        do {
            let timestamp = getTimestamp()
            
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
            
            let deleteResult = await retryOnCondition {
                await self.remoteUserPokemons.deleteAllForUser(userId: userId)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = deleteResult {
                switch error {
                    case .networkError: ()
                    case .failure(let actualError):
                        crashReporter.recordException(error: actualError, metadata: nil)
                }
            }
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: ["userId": userId])
            return .failure(.resetFailed)
        }
    }
}
