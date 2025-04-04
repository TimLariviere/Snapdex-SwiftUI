import GRDB

class LocalUserDataSource {
    private let database: SnapdexDatabase
    
    init(database: SnapdexDatabase) {
        self.database = database
    }
    
    func upsert(entity: UserEntity) async -> Result<Void, Error> {
        do {
            try await database.dbQueue.write { db in
                var mutableEntity = entity
                try mutableEntity.insert(db, onConflict: .replace)
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func delete(entity: UserEntity) async -> Result<Void, Error> {
        do {
            let _ = try await database.dbQueue.write { db in
                try entity.delete(db)
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func getById(id: String) async -> Result<UserEntity?, Error> {
        do {
            let entity = try await database.dbQueue.read { db in
                try UserEntity.filter(id: id).fetchOne(db)
            }
            
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
    
    func observeById(id: String) -> ValueObservation<ValueReducers.Fetch<UserEntity?>> {
        ValueObservation.tracking { db in
            try UserEntity.filter(id: id).fetchOne(db)
        }
    }
}
