import SnapdexDomain

public enum ChangeNameError: Error {
    case changeFailed
}

public enum ChangePasswordError: Error {
    case invalidOldPassword
    case invalidNewPassword
    case updatePasswordFailed
}

public protocol UserServicing : Sendable {
    func changeName(newName: String) async -> Result<Void, ChangeNameError>
    func changePassword(oldPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError>
}

final class UserService: UserServicing {
    private let analyticsTracker: AnalyticsTracker
    private let crashReporter: CrashReporter
    private let authProvider: AuthProvider
    private let localUsers: LocalUserDataSource
    private let remoteUsers: RemoteUserDataSource
    
    public init(analyticsTracker: AnalyticsTracker, crashReporter: CrashReporter, authProvider: AuthProvider, localUsers: LocalUserDataSource, remoteUsers: RemoteUserDataSource) {
        self.analyticsTracker = analyticsTracker
        self.crashReporter = crashReporter
        self.authProvider = authProvider
        self.localUsers = localUsers
        self.remoteUsers = remoteUsers
    }
    
    func changeName(newName: String) async -> Result<Void, ChangeNameError> {
        do {
            let userId = await authProvider.getCurrentUserId()
            
            guard let userId = userId else {
                analyticsTracker.logEvent(name: "no_current_user", parameters: nil)
                return .failure(.changeFailed)
            }
            
            let user = try await localUsers.getById(userId: userId)
            
            guard let user = user else {
                analyticsTracker.logEvent(name: "no_local_user", parameters: nil)
                return .failure(.changeFailed)
            }
            
            let updatedUser = Synced(value: User(id: user.value.id, avatarId: user.value.avatarId, name: newName, email: user.value.email), createdAt: user.createdAt, updatedAt: user.updatedAt)
            
            let upsertResult = await retryOnCondition {
                await self.remoteUsers.upsert(user: updatedUser)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = upsertResult {
                switch error {
                    case .networkError: ()
                    case .failure(let actualError):
                        crashReporter.recordException(error: actualError, metadata: nil)
                }
            }
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: nil)
            return .failure(.changeFailed)
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError> {
        do {
            let userId = await authProvider.getCurrentUserId()
            
            guard let userId = userId else {
                analyticsTracker.logEvent(name: "no_current_user", parameters: nil)
                return .failure(.updatePasswordFailed)
            }
            
            let user = try await localUsers.getById(userId: userId)
            
            guard let user = user?.value else {
                analyticsTracker.logEvent(name: "no_local_user", parameters: nil)
                return .failure(.updatePasswordFailed)
            }
            
            let reauthenticateResult = await retryOnCondition {
                await self.authProvider.reauthenticate(email: user.email, password: oldPassword)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = reauthenticateResult {
                let err: ChangePasswordError
                
                switch error {
                    case .invalidPasswordError: err = .invalidOldPassword
                    case .invalidEmailError: err = .updatePasswordFailed
                    case .networkError: err = .updatePasswordFailed
                    case .failure(let actualError):
                        crashReporter.recordException(error: actualError, metadata: nil)
                        err = .updatePasswordFailed
                }
                
                return .failure(err)
            }
            
            let updateResult = await retryOnCondition {
                await self.authProvider.updatePasswordForCurrentUser(newPassword: newPassword)
            } shouldRetry: { $0.isNetworkError }
            
            if case let .failure(error) = updateResult {
                let err: ChangePasswordError
                
                switch error {
                    case .invalidPasswordError: err = .invalidNewPassword
                    case .networkError: err = .updatePasswordFailed
                    case .failure(let actualError):
                        crashReporter.recordException(error: actualError, metadata: nil)
                        err = .updatePasswordFailed
                }
                
                return .failure(err)
            }
            
            return .success(())
        } catch {
            crashReporter.recordException(error: error, metadata: nil)
            return .failure(.updatePasswordFailed)
        }
    }
}
