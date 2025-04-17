import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable class LoginViewModel {
    let authService: AuthService
    
    var email: String = "" {
        didSet { validateForm() }
    }
    var password: String = "" {
        didSet { validateForm() }
    }
    var canLogin: Bool = false
    var isLoginIn: Bool = false
    var error: LocalizedStringKey? = nil
    
    let didLogin = PassthroughSubject<Void, Never>()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    private func validateForm() {
        canLogin = email.isNotBlank && password.isNotBlank
    }
    
    func login() async {
        self.isLoginIn = true
        
        let result = await authService.login(email: email, password: password)
        
        self.isLoginIn = false
        
        switch result {
            case .success(_): self.didLogin.send()
            case .failure(.loginFailed): self.error = "Login failed"
            case .failure(.invalidCredentials): self.error = "Incorrect email or password"
        }
        
        self.error = "Not implemented"
    }
}
