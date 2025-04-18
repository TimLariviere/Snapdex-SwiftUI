import SnapdexDomain
import SnapdexUseCases
import SnapdexUI

final class Configuration: AppDependencies {
    private let _authServicing: AuthServicing = AuthService()
    private let _userDataValidator: UserDataValidator = UserDataValidator()
    
    var authServicing: AuthServicing { _authServicing }
    var userDataValidator: UserDataValidator { _userDataValidator }
}
