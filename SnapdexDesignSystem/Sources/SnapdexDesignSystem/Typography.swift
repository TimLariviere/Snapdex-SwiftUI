import SwiftUI

public enum FontFamily: String, Sendable {
    case poppinsRegular = "Poppins-Regular"
    case poppinsMedium = "Poppins-Medium"
    case poppinsSemibold = "Poppins-SemiBold"
}

public struct FontStyle: Sendable {
    public var fontFamily: FontFamily
    public var fontWeight: Font.Weight
    public var fontSize: Int
    public var lineHeight: Int
    
    public init(fontFamily: FontFamily, fontWeight: Font.Weight, fontSize: Int, lineHeight: Int) {
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        self.lineHeight = lineHeight
    }
    
    public func withSize(_ size: Int) -> FontStyle {
        FontStyle(fontFamily: fontFamily, fontWeight: fontWeight, fontSize: size, lineHeight: lineHeight)
    }
}

public struct Typography: Sendable {
    public let heading1 = FontStyle(
        fontFamily: .poppinsSemibold,
        fontWeight: .semibold,
        fontSize: 32,
        lineHeight: 32
    )
    public let heading2 = FontStyle(
        fontFamily: .poppinsMedium,
        fontWeight: .medium,
        fontSize: 24,
        lineHeight: 24
    )
    public let heading3 = FontStyle(
        fontFamily: .poppinsSemibold,
        fontWeight: .semibold,
        fontSize: 18,
        lineHeight: 20
    )
    public let paragraph = FontStyle(
        fontFamily: .poppinsRegular,
        fontWeight: .regular,
        fontSize: 14,
        lineHeight: 17
    )
    public let primaryButton = FontStyle(
        fontFamily: .poppinsMedium,
        fontWeight: .medium,
        fontSize: 24,
        lineHeight: 28
    )
    public let secondaryButton = FontStyle(
        fontFamily: .poppinsRegular,
        fontWeight: .regular,
        fontSize: 18,
        lineHeight: 21
    )
    public let smallLabel = FontStyle(
        fontFamily: .poppinsRegular,
        fontWeight: .regular,
        fontSize: 10,
        lineHeight: 10
    )
    public let largeLabel = FontStyle(
        fontFamily: .poppinsSemibold,
        fontWeight: .semibold,
        fontSize: 14,
        lineHeight: 20
    )
    
    public init() {}
}

private struct FontStyleKey: EnvironmentKey {
    static let defaultValue = Typography().paragraph
}

extension EnvironmentValues {
    public var fontStyle: FontStyle {
        get { self[FontStyleKey.self] }
        set { self[FontStyleKey.self] = newValue }
    }
}

public extension View {
    func fontStyle(_ fontStyle: FontStyle) -> some View {
        self
            .font(.custom(fontStyle.fontFamily.rawValue, size: CGFloat(fontStyle.fontSize)))
            .environment(\.fontStyle, fontStyle)
            .lineSpacing(CGFloat(fontStyle.lineHeight - fontStyle.fontSize))
    }
}
