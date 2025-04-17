import SwiftUI

public struct Theme: Sendable {
    public let typography = Typography()
    public let shapes = Shapes()
    public let colors = Colors()
    
    public init() {}
}

private struct ThemeKey: EnvironmentKey {
  static let defaultValue = Theme()
}

extension EnvironmentValues {
    public var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
