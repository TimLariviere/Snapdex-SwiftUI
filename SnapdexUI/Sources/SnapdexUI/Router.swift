import SwiftUI

@MainActor @Observable final class Router<Screen: Hashable> {
    var path: [Screen] = []

    func push(_ screen: Screen) {
        path.append(screen)
    }

    func pop() {
        _ = path.popLast()
    }

    func reset() {
        path.removeAll()
    }
}
