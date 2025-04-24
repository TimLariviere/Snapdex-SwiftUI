import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class PokedexViewModel {
    var search: String
    var allPokemons: [Pokemon]
    
    private var cancellables: [AnyCancellable]
    
    private let classifier: Classifier
    private let authServicing: AuthServicing
    private let pokemonServicing: PokemonServicing

    init(deps: AppDependencies) {
        self.search = ""
        self.allPokemons = []
        self.cancellables = []
        self.classifier = deps.classifier
        self.authServicing = deps.authServicing
        self.pokemonServicing = deps.pokemonServicing
    }
    
    func start() {
        let cancellable =
            authServicing.getCurrentUserPublisher()
                .flatMap { user in
                    if let userId = user?.id {
                        self.pokemonServicing.getPokemonCaughtByUser(userId: userId)
                    } else {
                        Just([Pokemon]()).eraseToAnyPublisher()
                    }
                }
                .sink { pokemons in
                    self.allPokemons = pokemons
                }
        
        cancellables.append(cancellable)
    }
    
    func stop() {
        cancellables.forEach { $0.cancel() }
    }
}
