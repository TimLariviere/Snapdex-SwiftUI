import FirebaseFirestore
import SnapdexDomain

public final class FirebaseUserPokemonDataSource: RemoteUserPokemonDataSource {
    private let firestore: SendableFirestore
    
    public init() {
        self.firestore = SendableFirestore(firestore: Firestore.firestore())
    }
    
    public func getAllForUser(userId: UserId) async -> Result<[Synced<PokemonId>], GetAllForRemoteUserError> {
        do {
            let query = try await firestore.firestore.collection("user_pokemons")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let data = try query.documents.map { document in
                try document.data(as: UserPokemonRemoteEntity.self)
            }.map {
                $0.toSyncedPokemon()
            }
            
            return .success(data)
        } catch {
            let err: GetAllForRemoteUserError = switch FirestoreError.from(error) {
                case .firestoreNetworkError: .networkError
                default: .failure(error)
            }
            return .failure(err)
        }
    }
    
    public func upsert(userId: UserId, pokemon: Synced<PokemonId>) async -> Result<Void, UpsertRemoteUserPokemonError> {
        let entity = pokemon.toUserRemotePokemonEntity(userId: userId)
        return await withCheckedContinuation { continuation in
            do {
                let collection = firestore.firestore.collection("user_pokemons")
                let document = if let id = entity.id {
                    collection.document(id)
                } else {
                    collection.document()
                }
                
                try document.setData(from: entity) { error in
                    if let error = error {
                        let err: UpsertRemoteUserPokemonError = switch FirestoreError.from(error) {
                            case .firestoreNetworkError: .networkError
                            default: .failure(error)
                        }
                        continuation.resume(returning: .failure(err))
                    } else {
                        continuation.resume(returning: .success(()))
                    }
                }
            } catch {
                let err: UpsertRemoteUserPokemonError = switch FirestoreError.from(error) {
                    case .firestoreNetworkError: .networkError
                    default: .failure(error)
                }
                continuation.resume(returning: .failure(err))
            }
        }
    }
    
    public func deleteAllForUser(userId: UserId) async -> Result<Void, DeleteAllForRemoteUserError> {
        do {
            let snapshot =
                try await firestore.firestore.collection("user_pokemons")
                    .whereField("userId", isEqualTo: userId)
                    .getDocuments()
            
            for document in snapshot.documents {
                try await document.reference.delete()
            }
            
            return .success(())
        } catch {
            let err: DeleteAllForRemoteUserError = switch FirestoreError.from(error) {
                case .firestoreNetworkError: .networkError
                default: .failure(error)
            }
            return .failure(.failure(error))
        }
    }
}
