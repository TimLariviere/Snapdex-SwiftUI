import SwiftUI

class Container: ObservableObject {
    let userRepository: UserRepository = UserRepositoryImpl()
}
