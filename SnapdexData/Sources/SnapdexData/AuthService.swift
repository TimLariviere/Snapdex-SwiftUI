import Combine
import FirebaseAuth

enum AuthServiceError: Error {
    case firebase(AuthErrorCode)
    case unknown(Error)
    
    init(error: Error) {
        if let err = error as NSError?,
           err.domain == AuthErrorDomain,
           let code = AuthErrorCode.init(rawValue: err.code) {
                self = .firebase(code)
        } else {
            self = .unknown(error)
        }
    }
}

class AuthService: ObservableObject {
    @Published var currentUser: FirebaseAuth.User?
    
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(auth: Auth) {
        self.auth = auth
        self.handle = auth.addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }
    
    deinit {
        if let handle = self.handle {
            self.auth.removeStateDidChangeListener(handle)
            self.handle = nil
        }
    }
    
    func signIn(withEmail email: String, password: String) async -> Result<AuthDataResult, AuthServiceError> {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            return .success(authResult)
        } catch {
            return .failure(AuthServiceError(error: error))
        }
    }
    
    func sendPasswordResetEmail(email: String) async -> Result<Void, AuthServiceError> {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return .success(())
        } catch {
            return .failure(AuthServiceError(error: error))
        }
    }
}
