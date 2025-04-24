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

actor FirebaseAuthProviderState{
    private var handle: AuthStateDidChangeListenerHandle? = nil
    
    func addListener(auth: Auth, subject: CurrentValueSubject<UserId?, Never>) {
        self.handle = auth.addStateDidChangeListener { _, user in
            subject.send(user?.uid)
        }
        subject.send(auth.currentUser?.uid)
    }
    
    func removeListener(auth: Auth) {
        if let listener = handle {
            auth.removeStateDidChangeListener(listener)
            self.handle = nil
        }
    }
}

public final class FirebaseAuthProvider: AuthProvider, @unchecked Sendable {
    private let auth: Auth
    private let currentUserSubject: CurrentValueSubject<UserId?, Never>
    private let state: FirebaseAuthProviderState

    public init() {
        self.auth = Auth.auth()
        self.currentUserSubject = CurrentValueSubject(nil)
        self.state = FirebaseAuthProviderState()
        Task {
            await self.state.addListener(auth: auth, subject: currentUserSubject)
        }
    }
    
    public func stop() {
        Task {
            await self.state.removeListener(auth: auth)
        }
    }

    public func getCurrentUserId() -> UserId? {
        return currentUserSubject.value
    }
    
    public func getCurrentUserIdAsPublisher() -> AnyPublisher<UserId?, Never> {
        return currentUserSubject.eraseToAnyPublisher()
    }

    public func createUser(withEmail email: String, password: String) async -> Result<String, CreateUserError> {
        do {
            let uid = try await FirebaseHelpers.createUser(auth: auth, email: email, password: password)
            return .success(uid)
        } catch {
            return .failure(.failure(error))
        }
    }

    public func signIn(withEmail email: String, password: String) async -> Result<UserId, SignInError> {
        do {
            let uid = try await FirebaseHelpers.signIn(auth: auth, email: email, password: password)
            return .success(uid)
        } catch {
            return .failure(.failure(error))
        }
    }

    public func sendPasswordResetEmail(email: String) async -> Result<Void, AuthSendPasswordResetEmailError> {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return .success(())
        } catch {
            return .failure(.failure(error))
        }
    }
    
    public func signOut() async {
        do {
            try auth.signOut()
        } catch {
            // TODO
        }
    }
    
    public func deleteCurrentUser() async {
        do {
            if let currentUser = auth.currentUser {
                try auth.signOut()
                try await currentUser.delete()
            }
        } catch {
            // TODO
        }
    }
    
    public func reauthenticate(email: String, password: String) async -> Result<Void, ReauthenticateError> {
        return .success(())
    }
    
    public func updatePasswordForCurrentUser(newPassword: String) async -> Result<Void, UpdatePasswordError> {
        return .success(())
    }
}
