import Combine
import SwiftUI
import SnapdexDomain
import SnapdexUseCases

final class MockAuthService: AuthServicing {
    func isLoggedIn() async -> Bool {
        return false
    }
    
    func getCurrentUserPublisher() -> AnyPublisher<User?, Never> {
        return Just(
            User(id: "user", avatarId: 1, name: "Maximilian", email: "maximilian@snapdex.com")
        ).eraseToAnyPublisher()
    }
    
    func register(avatarId: AvatarId, name: String, email: String, password: String) async -> Result<Void, SnapdexUseCases.RegisterError> {
        return .success(())
    }
    
    func login(email: String, password: String) async -> Result<Void, SnapdexUseCases.LoginError> {
        return .success(())
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, SnapdexUseCases.SendPasswordResetEmailError> {
        return .success(())
    }
    
    func logout() async {
        
    }
    
    func deleteCurrentUser() async -> Result<Void, DeleteCurrentUserError> {
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
    func getPokemonCaughtByUser(userId: UserId) -> AnyPublisher<[Pokemon], Never> {
        return Just([
            Pokemon(
                id: 4,
                name: [ Locale(identifier: "en") : "Charmander" ],
                description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                types: [ .fire, .flying ],
                weaknesses: [ .bug ],
                weight: Measurement(value: 120, unit: .kilograms),
                height: Measurement(value: 1.7, unit: .meters),
                category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                maleToFemaleRatio: 0.875
            ),
            Pokemon(
                id: 5,
                name: [ Locale(identifier: "en") : "Charmeleon" ],
                description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                types: [ .fire, .flying ],
                weaknesses: [ .bug ],
                weight: Measurement(value: 120, unit: .kilograms),
                height: Measurement(value: 1.7, unit: .meters),
                category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                maleToFemaleRatio: 0.875
            ),
            Pokemon(
                id: 6,
                name: [ Locale(identifier: "en") : "Charizard" ],
                description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                types: [ .fire, .flying ],
                weaknesses: [ .bug ],
                weight: Measurement(value: 120, unit: .kilograms),
                height: Measurement(value: 1.7, unit: .meters),
                category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                maleToFemaleRatio: 0.875
            ),
        ]).eraseToAnyPublisher()
    }
    
    func getById(pokemonId: PokemonId) async -> Result<Pokemon?, GetPokemonByIdError> {
        return .success(
            Pokemon(
                id: 6,
                name: [ Locale(identifier: "en") : "Charizard" ],
                description: [ Locale(identifier: "en") : "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                types: [ .fire, .flying ],
                weaknesses: [ .bug ],
                weight: Measurement(value: 100, unit: .kilograms),
                height: Measurement(value: 1.7, unit: .meters),
                category: PokemonCategory(id: 0, name: [ Locale(identifier: "en") : "Lizard" ]),
                ability: PokemonAbility(id: 0, name: [ Locale(identifier: "en") : "Blaze" ]),
                maleToFemaleRatio: 0.875
            )
        )
    }
    
    func catchPokemon(userId: UserId, pokemonId: PokemonId) async -> Result<Void, CatchPokemonError> {
        return .success(())
    }
    
    func resetForUser(userId: UserId) async -> Result<Void, ResetForUserError> {
        return .success(())
    }
}

final class MockEvolutionChainDataSource: LocalEvolutionChainDataSource {
    func getForPokemon(pokemonId: PokemonId) async throws -> EvolutionChain? {
        return EvolutionChain(
            startingPokemon: Pokemon(
                id: 4,
                name: [ Locale(identifier: "en") : "Charmander" ],
                description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                types: [ .fire, .flying ],
                weaknesses: [ .bug ],
                weight: Measurement(value: 120, unit: .kilograms),
                height: Measurement(value: 1.7, unit: .meters),
                category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                maleToFemaleRatio: 0.875
            ),
            evolutions: [
                16: Pokemon(
                    id: 5,
                    name: [ Locale(identifier: "en") : "Charmeleon" ],
                    description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                    types: [ .fire, .flying ],
                    weaknesses: [ .bug ],
                    weight: Measurement(value: 120, unit: .kilograms),
                    height: Measurement(value: 1.7, unit: .meters),
                    category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                    ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                    maleToFemaleRatio: 0.875
                ),
                32: Pokemon(
                    id: 6,
                    name: [ Locale(identifier: "en") : "Charizard" ],
                    description: [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                    types: [ .fire, .flying ],
                    weaknesses: [ .bug ],
                    weight: Measurement(value: 120, unit: .kilograms),
                    height: Measurement(value: 1.7, unit: .meters),
                    category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                    ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                    maleToFemaleRatio: 0.875
                ),
            ]
        )
    }
}

final class MockStatisticsService: StatisticsServicing {
    func getCompletionRate(userId: SnapdexDomain.UserId) -> AnyPublisher<Statistic, Never> {
        return Just(Statistic(totalPokemonCount: 151, caughtPokemonCount: 75)).eraseToAnyPublisher()
    }
    
    func getCompletionRateByType(userId: SnapdexDomain.UserId) -> AnyPublisher<[PokemonType : Statistic], Never> {
        return Just(
            PokemonType.allCases.associate { type in
                (type, Statistic(totalPokemonCount: 151, caughtPokemonCount: 75))
            }
        )
        .eraseToAnyPublisher()
    }
}

final class MockUserService: UserServicing {
    func changeName(newName: String) async -> Result<Void, ChangeNameError> {
        return .success(())
    }
    
    func changePassword(oldPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError> {
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
    
    let _statisticsService = MockStatisticsService()
    var statisticsServicing: StatisticsServicing { _statisticsService }
    
    let _userService = MockUserService()
    var userServicing: UserServicing { _userService }
    
    let _localEvolutionChains = MockEvolutionChainDataSource()
    var localEvolutionChains: LocalEvolutionChainDataSource { _localEvolutionChains }
}
