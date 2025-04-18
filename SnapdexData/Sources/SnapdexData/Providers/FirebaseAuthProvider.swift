import Combine
import FirebaseAuth
import SnapdexDomain

// FirebaseAuth is not compatible with Swift strict concurrency
enum FirebaseHelpers {
    static func createUser(auth: Auth, email: String, password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    static func signIn(auth: Auth, email: String, password: String) async throws -> String {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user.uid
    }
}

@MainActor
final class FirebaseAuthProvider: AuthProvider {
    private let auth: Auth
    private var handle: AuthStateDidChangeListenerHandle?

    init(auth: Auth) {
        self.auth = auth
        self.handle = auth.addStateDidChangeListener { [weak self] _, user in
            self?.currentUserId = user?.uid
        }
    }

    var currentUserId: UserId?
    
    func stop() {
        if let handle = self.handle {
            auth.removeStateDidChangeListener(handle)
            self.handle = nil
        }
    }

    func createUser(withEmail email: String, password: String) async -> Result<String, CreateUserError> {
        do {
            let uid = try await FirebaseHelpers.createUser(auth: auth, email: email, password: password)
            return .success(uid)
        } catch {
            return .failure(.failure(error))
        }
    }

    func signIn(withEmail email: String, password: String) async -> Result<UserId, SignInError> {
        do {
            let uid = try await FirebaseHelpers.signIn(auth: auth, email: email, password: password)
            return .success(uid)
        } catch {
            return .failure(.failure(error))
        }
    }

    func sendPasswordResetEmail(email: String) async -> Result<Void, AuthSendPasswordResetEmailError> {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return .success(())
        } catch {
            return .failure(.failure(error))
        }
    }
}
