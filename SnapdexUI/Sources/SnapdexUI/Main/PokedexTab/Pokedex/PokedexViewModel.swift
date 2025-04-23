import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class PokedexViewModel {
    var search: String
    var allPokemons: [Pokemon]
    
    private let pokemonsPublisher: AnyPublisher<[Pokemon], Never>
    private var cancellables: [AnyCancellable]
    
    private let classifier: Classifier
    private let pokemonServicing: PokemonServicing

    init(deps: AppDependencies, pokemonsPublisher: AnyPublisher<[Pokemon], Never>) {
        self.search = ""
        self.allPokemons = []
        self.pokemonsPublisher = pokemonsPublisher
        self.cancellables = []
        self.classifier = deps.classifier
        self.pokemonServicing = deps.pokemonServicing
    }
    
    func start() {
        cancellables.append(
            pokemonsPublisher.sink { pokemons in
                self.allPokemons = pokemons
            }
        )
    }
    
    func stop() {
        cancellables.forEach { $0.cancel() }
    }
}
