import Combine
import GRDB
import SnapdexDomain

public final class UserDataSource : LocalUserDataSource {
    private let database: SnapdexDatabase
    
    public init(database: SnapdexDatabase) {
        self.database = database
    }
    
    public func observeById(userId: UserId) -> AnyPublisher<Synced<User>, Error> {
        let observation = ValueObservation.tracking { db in
            try UserEntity.filter(id: userId).fetchOne(db)
        }
        
        return observation.publisher(in: database.dbQueue)
            .compactMap { $0?.toSyncedUser() }
            .eraseToAnyPublisher()
    }
    
    public func getById(userId: UserId) async throws -> Synced<User>? {
        let entity = try await database.dbQueue.read { db in
            try UserEntity.filter(id: userId).fetchOne(db)
        }
        
        return entity?.toSyncedUser()
    }
    
    public func upsert(user: Synced<User>) async throws {
        let userEntity = user.toUserEntity()
        try await database.dbQueue.write { db in
            let mutableEntity = userEntity
            try mutableEntity.insert(db, onConflict: .replace)
        }
    }
    
    public func delete(userId: UserId) async throws {
        let _ = try await database.dbQueue.write { db in
            try UserEntity.deleteOne(db, id: userId)
        }
    }
}
