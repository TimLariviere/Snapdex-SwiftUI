import SwiftUI

public enum SnapdexIconName : String {
    case add = "Add"
    case check = "Check"
    case close = "Close"
    case error = "Error"
    case eye = "Eye"
    case eyeClosed = "EyeClosed"
    case search = "Search"
    case gridSelected = "GridSelected"
    case gridUnselected = "GridUnselected"
    case statsSelected = "StatsSelected"
    case statsUnselected = "StatsUnselected"
    case profileSelected = "ProfileSelected"
    case profileUnselected = "ProfileUnselected"
    case pokeball = "Pokeball"
}

public struct SnapdexIcon : View {
    let iconName: SnapdexIconName
    
    public init(_ iconName: SnapdexIconName) {
        self.iconName = iconName
    }
    
    public var body: some View {
        Image(iconName.rawValue, bundle: .module)
            .resizable()
            .scaledToFit()
    }
}
