import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    @Published var avatar: Int = -1
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordValidationState = PasswordValidationState()
    @Published var isRegistering: Bool = false
    @Published var canRegister: Bool = false
    
    var didRegister = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $password
            .sink { [weak self] value in
                self?.passwordValidationState = UserDataValidator.validatePassword(value)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4($name, $email, $passwordValidationState, $isRegistering)
            .map { name, email, passwordValidationState, isRegistering in
                if (isRegistering) {
                    return false
                } else {
                    let isNameValid = UserDataValidator.validateName(name)
                    let isEmailValid = UserDataValidator.validateEmail(email)
                    return isNameValid && isEmailValid && passwordValidationState.isValid
                }
            }
            .sink { [weak self] canRegister in
                self?.canRegister = canRegister
            }
            .store(in: &cancellables)
    }
    
    func register() {
        isRegistering = true
        
        // do stuff
        
        isRegistering = false
        
        didRegister.send()
    }
}
