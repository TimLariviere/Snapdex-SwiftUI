import SwiftUI

public enum SnapdexIconName : String {
    case search = "Search"
}

public struct SnapdexIcon : View {
    let iconName: SnapdexIconName
    
    public init(_ iconName: SnapdexIconName) {
        self.iconName = iconName
    }
    
    public var body: some View {
        Image(iconName.rawValue, bundle: .module)
    }
}
