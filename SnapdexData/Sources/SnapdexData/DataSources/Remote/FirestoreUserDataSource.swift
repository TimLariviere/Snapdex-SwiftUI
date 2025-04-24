import FirebaseFirestore
import SnapdexDomain

struct SendableFirestore : @unchecked Sendable {
    let firestore: Firestore
}

public final class FirestoreUserDataSource : RemoteUserDataSource {
    private let firestore: SendableFirestore
    
    public init() {
        self.firestore = SendableFirestore(firestore: Firestore.firestore())
    }
    
    public func getById(userId: UserId) async -> Result<Synced<User>?, GetRemoteUserError> {
        do {
            let entity = try await withCheckedThrowingContinuation { continuation in
                firestore.firestore.collection("users")
                    .document(userId)
                    .getDocument(as: UserRemoteEntity.self) { result in
                        switch result {
                            case .success(let entity):
                                continuation.resume(returning: entity)
                            case .failure(let error):
                                continuation.resume(throwing: error)
                        }
                    }
            }

            return .success(entity.toSyncedUser())
        }
        catch {
            let err: GetRemoteUserError = switch FirestoreError.from(error) {
                case .firestoreNetworkError: .networkError
                default: .failure(error)
            }
            return .failure(err)
        }
    }
    
    public func upsert(user: Synced<User>) async -> Result<Void, UpsertRemoteUserError> {
        let entity = user.toUserRemoteEntity()
        return await withCheckedContinuation { continuation in
            do {
                try firestore.firestore.collection("users")
                    .document(entity.id!)
                    .setData(from: entity) { error in
                        if let error = error {
                            let err: UpsertRemoteUserError = switch FirestoreError.from(error) {
                                case .firestoreNetworkError: .networkError
                                default: .failure(error)
                            }
                            continuation.resume(returning: .failure(err))
                        } else {
                            continuation.resume(returning: .success(()))
                        }
                    }
            } catch {
                let err: UpsertRemoteUserError = switch FirestoreError.from(error) {
                    case .firestoreNetworkError: .networkError
                    default: .failure(error)
                }
                continuation.resume(returning: .failure(err))
            }
        }
    }

    
    public func delete(userId: UserId) async -> Result<Void, DeleteRemoteUserError> {
        do {
            try await firestore.firestore.collection("users")
                .document(userId)
                .delete()
            
            return .success(())
        } catch {
            let err: DeleteRemoteUserError = switch FirestoreError.from(error) {
                case .firestoreNetworkError: .networkError
                default: .failure(error)
            }
            return .failure(err)
        }
    }
}
