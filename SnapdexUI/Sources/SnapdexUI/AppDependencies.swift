import SwiftUI
import SnapdexDomain
import SnapdexUseCases

public protocol AppDependencies: Sendable {
    var authServicing: AuthServicing { get }
    var classifier: Classifier { get }
    var pokemonServicing: PokemonServicing { get }
    var userDataValidator: UserDataValidator { get }
    var statisticsServicing: StatisticsServicing { get }
    var userServicing: UserServicing { get }
    var localEvolutionChains: LocalEvolutionChainDataSource { get }
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies = {
        fatalError("AppDependencies not set. Inject it using .environment(\\.\(AppDependenciesKey.self))")
    }()
}

extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
