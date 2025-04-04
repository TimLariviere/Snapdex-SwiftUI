import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var canLogin = false
    @Published var isLoginIn = false
    
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
        await MainActor.run { isLoginIn = true }
        
        let result = await userRepository.login(email: email, password: password)
        
        await MainActor.run { isLoginIn = false }
        
        switch result {
            case .failure(let error):
                switch error {
                    case .invalidCredentials:
                        ()
                    case .loginFailed:
                        ()
                }
            
            case .success(_):
                await MainActor.run { didLogin.send() }
        }
    }
}
