import SwiftUI

public enum FontFamily: String, Sendable {
    case poppinsRegular = "Poppins-Regular"
    case poppinsMedium = "Poppins-Medium"
    case poppinsSemibold = "Poppins-SemiBold"
}

public struct FontStyle: Sendable {
    var fontFamily: FontFamily
    var fontSize: Int
    var lineHeight: Int
    
    public init(fontFamily: FontFamily, fontSize: Int, lineHeight: Int) {
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.lineHeight = lineHeight
    }
}

public struct Typography: Sendable {
    public let heading1 = FontStyle(
        fontFamily: FontFamily.poppinsSemibold,
        fontSize: 32,
        lineHeight: 32
    )
    public let heading2 = FontStyle(
        fontFamily: FontFamily.poppinsMedium,
        fontSize: 24,
        lineHeight: 24
    )
    public let heading3 = FontStyle(
        fontFamily: FontFamily.poppinsSemibold,
        fontSize: 18,
        lineHeight: 20
    )
    public let paragraph = FontStyle(
        fontFamily: FontFamily.poppinsRegular,
        fontSize: 14,
        lineHeight: 17
    )
    public let primaryButton = FontStyle(
        fontFamily: FontFamily.poppinsMedium,
        fontSize: 24,
        lineHeight: 28
    )
    public let secondaryButton = FontStyle(
        fontFamily: FontFamily.poppinsRegular,
        fontSize: 18,
        lineHeight: 21
    )
    public let smallLabel = FontStyle(
        fontFamily: FontFamily.poppinsRegular,
        fontSize: 10,
        lineHeight: 10
    )
    public let largeLabel = FontStyle(
        fontFamily: FontFamily.poppinsSemibold,
        fontSize: 14,
        lineHeight: 20
    )
    
    public init() {}
}

public extension View {
    func fontStyle(_ fontStyle: FontStyle) -> some View {
        self
            .font(.custom(fontStyle.fontFamily.rawValue, size: CGFloat(fontStyle.fontSize)))
            .lineSpacing(CGFloat(fontStyle.lineHeight - fontStyle.fontSize))
    }
}
