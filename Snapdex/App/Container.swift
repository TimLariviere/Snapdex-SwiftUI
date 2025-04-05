import SwiftUI
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseFirestore

class Container: ObservableObject {
    let userRepository: UserRepository
    
    init() {
        let auth = Auth.auth()
        let crashlytics = Crashlytics.crashlytics()
        let firestore = Firestore.firestore()
        
        let database = SnapdexDatabase()
        let authService = AuthService(auth: auth)
        let localUserDataSource = LocalUserDataSource(database: database)
        let localUserPokemonDataSource = LocalUserPokemonDataSource()
        let remoteUserDataSource = RemoteUserDataSource(firestore: firestore)
        let remoteUserPokemonDataSource = RemoteUserPokemonDataSource(firestore: firestore)
        
        self.userRepository = UserRepositoryImpl(crashlytics: crashlytics, authService: authService, database: database, localUsers: localUserDataSource, localUserPokemons: localUserPokemonDataSource, remoteUsers: remoteUserDataSource, remoteUserPokemons: remoteUserPokemonDataSource)
    }
}
