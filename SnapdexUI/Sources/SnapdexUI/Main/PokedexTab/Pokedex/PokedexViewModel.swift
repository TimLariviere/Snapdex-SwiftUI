import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class PokedexViewModel {
    var search: String = "" {
        didSet {
            debouncedSearch.send(search)
        }
    }
    var allPokemons: [Pokemon] = []
    var filteredPokemons: [Pokemon]? = nil
    var recognitionState: RecognitionState? = nil
    
    @ObservationIgnored private var debouncedSearch = CurrentValueSubject<String, Never>("")
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    private let classifier: Classifier
    private let authServicing: AuthServicing
    private let pokemonServicing: PokemonServicing

    init(deps: AppDependencies) {
        self.classifier = deps.classifier
        self.authServicing = deps.authServicing
        self.pokemonServicing = deps.pokemonServicing
        
        debouncedSearch
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .dropFirst()
            .sink { [weak self] searchText in
                self?.performSearch(searchText: searchText)
            }
            .store(in: &cancellables)
        
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
            .store(in: &cancellables)
    }
    
    func startRecognition() {
        self.recognitionState = RecognitionState(isRecognizing: true, caught: nil)
        
        Task {
            try await Task.sleep(for: .seconds(2))
            let pokemon = allPokemons.randomElement()!
            let pokemonCaught = PokemonCaught(id: pokemon.id, name: pokemon.name)
            self.recognitionState = RecognitionState(isRecognizing: false, caught: pokemonCaught)
        }
    }
    
    func stopRecognition() {
        self.recognitionState = nil
    }
    
    private func performSearch(searchText: String) {
        if searchText.isNotBlank {
            filteredPokemons = allPokemons.filter { $0.name.translated(Locale.current).localizedCaseInsensitiveContains(searchText)  }
        } else {
            filteredPokemons = nil
        }
    }
}
