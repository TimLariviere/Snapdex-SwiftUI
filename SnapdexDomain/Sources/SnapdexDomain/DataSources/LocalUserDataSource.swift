import Combine

public protocol LocalUserDataSource : Sendable {
    func observeById(userId: UserId) -> AnyPublisher<Synced<User>, Error>
    func getById(userId: UserId) async throws -> Synced<User>?
    func upsert(user: Synced<User>) async throws
    func delete(userId: UserId) async throws
}
