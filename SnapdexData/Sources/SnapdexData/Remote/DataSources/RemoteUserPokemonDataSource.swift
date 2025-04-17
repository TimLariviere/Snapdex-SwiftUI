import FirebaseFirestore

class RemoteUserPokemonDataSource {
    private let firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func getAllForUser(userId: String) async -> Result<[UserPokemonRemoteEntity], Error> {
        do {
            let query = try await firestore.collection("user_pokemons")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let data = try query.documents.map { document in
                try document.data(as: UserPokemonRemoteEntity.self)
            }
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func upsert(userPokemonRemoteEntity: UserPokemonRemoteEntity) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            do {
                let collection = firestore.collection("user_pokemons")
                let document = if let id = userPokemonRemoteEntity.id {
                    collection.document(id)
                } else {
                    collection.document()
                }
                
                try document.setData(from: userPokemonRemoteEntity) { error in
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
    
    func exists(userId: String, pokemonId: Int) async -> Result<Bool, Error> {
        do {
            let snapshot =
                try await firestore.collection("user_pokemons")
                    .whereField("userId", isEqualTo: userId)
                    .whereField("pokemonId", isEqualTo: pokemonId)
                    .count
                    .getAggregation(source: AggregateSource.server)
            
            return .success(snapshot.count.intValue > 0)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(userPokemonRemoteEntity: UserPokemonRemoteEntity) async -> Result<Void, Error> {
        do {
            try await firestore.collection("user_pokemons")
                .document(userPokemonRemoteEntity.id!)
                .delete()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAllForUser(userId: String) async -> Result<Void, Error> {
        do {
            let snapshot =
                try await firestore.collection("user_pokemons")
                    .whereField("userId", isEqualTo: userId)
                    .getDocuments()
            
            for document in snapshot.documents {
                try await document.reference.delete()
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
