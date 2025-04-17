import SwiftUI

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

public struct Shapes: Sendable {
    public var regular : some Shape { RoundedRectangle(cornerRadius: 10) }
    public var small : some Shape { RoundedRectangle(cornerRadius: 26) }
    public var navBar : some Shape { RoundedRectangle(cornerRadius: 200) }
    public var navBarIndicator : some Shape { RoundedCorner(radius: 10, corners: [.topLeft, .topRight]) }
    
    public init() {}
}
