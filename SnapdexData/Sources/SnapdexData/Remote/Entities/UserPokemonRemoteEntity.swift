import FirebaseFirestore

struct UserPokemonRemoteEntity: Codable {
    @DocumentID var id: String?
    let userId: String
    let pokemonId: Int
    let createdAt: UInt64
    let updatedAt: UInt64
}
