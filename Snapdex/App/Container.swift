import SwiftUI
import FirebaseAuth

class Container: ObservableObject {
    let userRepository: UserRepository
    
    init() {
        let database = SnapdexDatabase()
        let authService = AuthService(auth: Auth.auth())
        let localUserDataSource = LocalUserDataSource(database: database)
        
        self.userRepository = UserRepositoryImpl(authService: authService, database: database, localUsers: localUserDataSource)
    }
}
