import SnapdexDomain
import Combine
import SnapdexUseCases

final class MockAuthService: AuthServicing {
    func login(email: String, password: String) async -> Result<Void, SnapdexUseCases.LoginError> {
        return .success(())
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, SnapdexUseCases.SendPasswordResetEmailError> {
        return .success(())
    }
    
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, SnapdexUseCases.RegisterError> {
        return .success(())
    }
}

final class MockClassifier : Classifier {
    func initialize() async {
        
    }
    
    func classify(bitmap: [UInt8]) async -> PokemonId? {
        return nil
    }
}

final class MockPokemonService: PokemonServicing {
    func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Error> {
        return CurrentValueSubject<[Pokemon], Error>([]).eraseToAnyPublisher()
    }
    
    func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError> {
        return .success(nil)
    }
    
    func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError> {
        return .success(())
    }
    
    func resetForUser(userId: UserId) async -> Result<Void, ResetForUserError> {
        return .success(())
    }
}

final class MockAppDependencies : AppDependencies {
    static let shared = MockAppDependencies()
    
    let _authServicing = MockAuthService()
    var authServicing: AuthServicing { _authServicing }
    
    let _userDataValidator = UserDataValidator()
    var userDataValidator: UserDataValidator { _userDataValidator }
    
    let _classifier = MockClassifier()
    var classifier: Classifier { _classifier }
    
    let _pokemonService = MockPokemonService()
    var pokemonServicing: PokemonServicing { _pokemonService }
}
