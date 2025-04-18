import SwiftUI
import SnapdexDomain
import SnapdexUseCases

public protocol AppDependencies: Sendable {
    var authServicing: AuthServicing { get }
    var userDataValidator: UserDataValidator { get }
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
