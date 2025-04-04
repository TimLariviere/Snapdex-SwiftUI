import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isSendingEmail: Bool = false
    @Published var canSendEmail: Bool = false
    @Published var sendEmailError: SendPasswordResetEmailError? = .none
    
    let didSentEmail = PassthroughSubject<Void, Never>()
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(container: Container) {
        userRepository = container.userRepository
        
        Publishers.CombineLatest($email, $isSendingEmail)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email, isSendingEmail in
                let isEmailValid = UserDataValidator.validateEmail(email)
                self?.canSendEmail = isEmailValid && !isSendingEmail
            }
            .store(in: &cancellables)
    }
    
    func sendPasswordResetEmail() {
        Task {
            await performSendPasswordResetEmail()
        }
    }
    
    private func performSendPasswordResetEmail() async {
        await MainActor.run { isSendingEmail = true }
        
        let result = await userRepository.sendPasswordResetEmail(email: email)
        
        await MainActor.run {
            isSendingEmail = false
            
            switch result {
                case .success(_): didSentEmail.send()
                case .failure(let error): sendEmailError = error
            }
        }
    }
}
