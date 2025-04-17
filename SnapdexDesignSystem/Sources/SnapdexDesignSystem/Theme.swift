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

public struct AppTheme<Content: View>: View {
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        let theme = Theme()
        
        content()
            .environment(\.theme, theme)
            .foregroundStyle(theme.colors.onBackground)
            .fontStyle(theme.typography.paragraph)
    }
}
