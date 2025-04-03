import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var canLogin = false
    @Published var isLoginIn = false
    
    func login() {
        isLoginIn = true
    }
}
