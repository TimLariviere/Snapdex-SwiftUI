import SwiftUI

struct Theme {
    var typography = Typography()
    var shapes = Shapes()
    var colors = Colors()
}

private struct ThemeKey: EnvironmentKey {
  static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
