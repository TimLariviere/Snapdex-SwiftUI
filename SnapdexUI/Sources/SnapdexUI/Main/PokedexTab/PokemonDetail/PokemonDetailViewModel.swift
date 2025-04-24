import SwiftUI
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable class PokemonDetailViewModel {
    var pokemon: Pokemon? = nil
    var evolutionChain: EvolutionChain? = nil
    
    private let pokemonId: PokemonId
    private let pokemonService: PokemonServicing
    private let localEvolutionChains: LocalEvolutionChainDataSource
    
    init(deps: AppDependencies, pokemonId: PokemonId) {
        self.pokemonId = pokemonId
        self.pokemonService = deps.pokemonServicing
        self.localEvolutionChains = deps.localEvolutionChains
    }
    
    func loadPokemon() async {
        do {
            pokemon = try await pokemonService.getById(pokemonId: pokemonId).get()
            evolutionChain = try await localEvolutionChains.getForPokemon(pokemonId: pokemonId)!
        } catch {
            
        }
    }
}
