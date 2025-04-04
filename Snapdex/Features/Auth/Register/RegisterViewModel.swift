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
    @Published var registerError: RegisterError? = nil
    
    let didRegister = PassthroughSubject<Void, Never>()
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(container: Container) {
        userRepository = container.userRepository
        
        $password
            .sink { [weak self] value in
                self?.passwordValidationState = UserDataValidator.validatePassword(value)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4($avatar, $name, $email, $passwordValidationState)
            .combineLatest($isRegistering)
            .map { fields, isRegistering in
                let (avatar, name, email, passwordValidationState) = fields
                
                if (isRegistering) {
                    return false
                } else {
                    let isAvatarValid = avatar > -1
                    let isNameValid = UserDataValidator.validateName(name)
                    let isEmailValid = UserDataValidator.validateEmail(email)
                    return isAvatarValid && isNameValid && isEmailValid && passwordValidationState.isValid
                }
            }
            .sink { [weak self] canRegister in
                self?.canRegister = canRegister
            }
            .store(in: &cancellables)
    }
    
    func register() {
        Task {
            await performRegister()
        }
    }
    
    func pickAvatar(_ avatar: Int) {
        self.avatar = avatar
    }
    
    private func performRegister() async {
        await MainActor.run { isRegistering = true }
        
        let result = await userRepository.register(avatarId: avatar, name: name, email: email, password: password)
        
        await MainActor.run {
            isRegistering = false
            
            switch result {
                case .success(_):
                    didRegister.send()
                case .failure(let error):
                    registerError = error
            }
        }
    }
}
