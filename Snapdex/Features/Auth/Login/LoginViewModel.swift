import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var canLogin = false
    @Published var isLoginIn = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
        isLoginIn = true
        
        // do stuff
        
        isLoginIn = false
    }
}
