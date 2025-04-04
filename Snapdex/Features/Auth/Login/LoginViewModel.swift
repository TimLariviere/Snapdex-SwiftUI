import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var canLogin = false
    @Published var isLoggingIn = false
    @Published var loginError: LoginError? = nil
    
    let didLogin = PassthroughSubject<Void, Never>()
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(container: Container) {
        userRepository = container.userRepository
        
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return email.isNotBlank && password.isNotBlank
            }
            .sink { [weak self] isValid in
                self?.canLogin = isValid
            }
            .store(in: &cancellables)
    }
    
    func login() {
        Task {
            await performLogin()
        }
    }
    
    private func performLogin() async {
        await MainActor.run { isLoggingIn = true }
        
        let result = await userRepository.login(email: email, password: password)
        
        await MainActor.run {
            isLoggingIn = false
            
            switch result {
                case .failure(let error): loginError = error
                case .success(_): didLogin.send()
            }
        }
    }
}
