import FirebaseFirestore

class RemoteUserDataSource {
    private let firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func upsert(user: UserRemoteEntity) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            do {
                try firestore.collection("users")
                    .document(user.id!)
                    .setData(from: user) { error in
                        if let error = error {
                            continuation.resume(returning: .failure(error))
                        } else {
                            continuation.resume(returning: .success(()))
                        }
                    }
            } catch {
                continuation.resume(returning: .failure(error))
            }
        }
    }
    
    func get(id: String) async -> Result<UserRemoteEntity?, Error> {
        await withCheckedContinuation { continuation in
            firestore.collection("users")
                .document(id)
                .getDocument(as: UserRemoteEntity.self) { result in
                    switch result {
                        case .success(let entity): continuation.resume(returning: .success(entity))
                        case .failure(let error): continuation.resume(returning: .failure(error))
                    }
                }
        }
    }
    
    func delete(id: String) async -> Result<Void, Error> {
        do {
            try await firestore.collection("users")
                .document(id)
                .delete()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
