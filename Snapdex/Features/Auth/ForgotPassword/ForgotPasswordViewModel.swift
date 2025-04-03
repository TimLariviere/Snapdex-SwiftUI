import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isSendingEmail: Bool = false
    @Published var canSendEmail: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($email, $isSendingEmail)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email, isSendingEmail in
                let isEmailValid = UserDataValidator.validateEmail(email)
                self?.canSendEmail = isEmailValid && !isSendingEmail
            }
            .store(in: &cancellables)
    }
    
    func sendPasswordResetEmail() async -> Bool {
        await MainActor.run { isSendingEmail = true }
        
        // do stuff
        
        await MainActor.run { isSendingEmail = false }
        
        return true
    }
}
