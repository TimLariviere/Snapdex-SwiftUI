import SwiftUI

public struct Colors: Sendable {
    public var primary: Color { Color("Primary", bundle: .module) }
    public var onPrimary: Color { Color("OnPrimary", bundle: .module) }
    public var secondary: Color { Color("Secondary", bundle: .module) }
    public var background: Color { Color("Background", bundle: .module) }
    public var backgroundVariant: Color { Color("BackgroundVariant", bundle: .module) }
    public var onBackground: Color { Color("OnBackground", bundle: .module) }
    public var surface: Color { Color("Surface", bundle: .module) }
    public var surfaceVariant: Color { Color("SurfaceVariant", bundle: .module) }
    public var onSurface: Color { Color("OnSurface", bundle: .module) }
    public var onSurfaceVariant: Color { Color("OnSurfaceVariant", bundle: .module) }
    public var outline: Color { Color("Outline", bundle: .module) }
    public var inOutline: Color { Color("InOutline", bundle: .module) }
    public var success: Color { Color("Success", bundle: .module) }
    public var error: Color { Color("Error", bundle: .module) }
    public var onError: Color { Color("OnError", bundle: .module) }
    public var shadow: Color { Color("Shadow", bundle: .module) }
    public var navBarBackground: Color { Color("NavBarBackground", bundle: .module) }
    public var navBarOnBackground: Color { Color("NavBarOnBackground", bundle: .module) }
    public var statsFill: Color { Color("StatsFill", bundle: .module) }
    
    public init() {}
}
