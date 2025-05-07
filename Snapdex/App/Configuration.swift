import SnapdexDomain
import SnapdexUseCases
import SnapdexData
import SnapdexUI

final class Configuration: AppDependencies {
    private let _authServicing: AuthServicing
    private let _classifier: Classifier
    private let _pokemonServicing: PokemonServicing
    private let _userDataValidator: UserDataValidator
    private let _statisticsServicing: StatisticsServicing
    private let _localEvolutionChains: LocalEvolutionChainDataSource
    
    init() {
        let analyticsTracker = FirebaseAnalyticsTracker()
        let crashReporter = FirebaseCrashReporter()
        let authProvider = FirebaseAuthProvider()
        let database = SnapdexDatabase()
        let localUsers = UserDataSource(database: database)
        let localUserPokemons = UserPokemonDataSource(database: database)
        let localPokemons = PokemonDataSource(database: database)
        let localStatistics = StatisticsDataSource(database: database)
        let remoteUsers = FirestoreUserDataSource()
        let remoteUserPokemons = FirebaseUserPokemonDataSource()
        
        self._authServicing = AuthService(analyticsTracker: analyticsTracker, crashReporter: crashReporter, authProvider: authProvider, localUsers: localUsers, localUserPokemons: localUserPokemons, remoteUsers: remoteUsers, remoteUserPokemons: remoteUserPokemons)
        self._userDataValidator = UserDataValidator()
        self._classifier = ClassifierFactory()
        self._pokemonServicing = PokemonService(crashReporter: crashReporter, localUserPokemons: localUserPokemons, localPokemons: localPokemons, remoteUserPokemons: remoteUserPokemons)
        self._statisticsServicing = StatisticsService(crashReporter: crashReporter, localStatistics: localStatistics)
        self._localEvolutionChains = EvolutionChainDataSource(database: database)
    }
    
    var authServicing: AuthServicing { _authServicing }
    var userDataValidator: UserDataValidator { _userDataValidator }
    var classifier: Classifier { _classifier }
    var pokemonServicing: PokemonServicing { _pokemonServicing }
    var statisticsServicing: StatisticsServicing { _statisticsServicing }
    var localEvolutionChains: LocalEvolutionChainDataSource { _localEvolutionChains }
}
