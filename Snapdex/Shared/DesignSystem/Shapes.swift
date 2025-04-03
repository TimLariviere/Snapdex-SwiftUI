import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct Shapes {
    var regular : some Shape { RoundedRectangle(cornerRadius: 10) }
    var small : some Shape { RoundedRectangle(cornerRadius: 26) }
    var navBar : some Shape { RoundedRectangle(cornerRadius: 200) }
    var navBarIndicator : some Shape { RoundedCorner(radius: 10, corners: [.topLeft, .topRight]) }
}
