import SwiftUI
import SnapdexDesignSystem

enum AuthDestination: Hashable {
    case register
    case forgotPassword
}

public struct AuthCoordinator: View {
    public init() {}
    
    public var body: some View {
        LoginScreen()
    }
}

#Preview {
    AppTheme {
        AuthCoordinator()
    }
}
