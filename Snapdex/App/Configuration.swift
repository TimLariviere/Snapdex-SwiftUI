import SnapdexDomain
import SnapdexUseCases
import SnapdexData
import SnapdexUI

final class Configuration: AppDependencies {
    private let _authServicing: AuthServicing
    private let _classifier: Classifier
    private let _pokemonServicing: PokemonServicing
    private let _userDataValidator: UserDataValidator
    
    init() {
        let analyticsTracker = FirebaseAnalyticsTracker()
        let crashReporter = FirebaseCrashReporter()
        let authProvider = FirebaseAuthProvider()
        let database = SnapdexDatabase()
        let localUsers = UserDataSource(database: database)
        let localUserPokemons = UserPokemonDataSource(database: database)
        let localPokemons = PokemonDataSource(database: database)
        let remoteUsers = FirestoreUserDataSource()
        let remoteUserPokemons = FirebaseUserPokemonDataSource()
        
        self._authServicing = AuthService(analyticsTracker: analyticsTracker, crashReporter: crashReporter, authProvider: authProvider, localUsers: localUsers, localUserPokemons: localUserPokemons, remoteUsers: remoteUsers, remoteUserPokemons: remoteUserPokemons)
        self._userDataValidator = UserDataValidator()
        self._classifier = ClassifierFactory()
        self._pokemonServicing = PokemonService(crashReporter: crashReporter, localUserPokemons: localUserPokemons, localPokemons: localPokemons, remoteUserPokemons: remoteUserPokemons)
    }
    
    var authServicing: AuthServicing { _authServicing }
    var userDataValidator: UserDataValidator { _userDataValidator }
    var classifier: Classifier { _classifier }
    var pokemonServicing: PokemonServicing { _pokemonServicing }
}
