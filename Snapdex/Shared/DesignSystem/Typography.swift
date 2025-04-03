import SwiftUI

enum FontFamily: String {
    case poppins = "Poppins"
}

struct FontStyle {
    var fontFamily: FontFamily
    var fontWeight: Font.Weight
    var fontSize: Int
    var lineHeight: Int
    
    init(fontFamily: FontFamily, fontWeight: Font.Weight, fontSize: Int, lineHeight: Int) {
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        self.lineHeight = lineHeight
    }
}

struct Typography {
    var heading1 = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.semibold,
        fontSize: 32,
        lineHeight: 32
    )
    var heading2 = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.medium,
        fontSize: 24,
        lineHeight: 24
    )
    var heading3 = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.semibold,
        fontSize: 18,
        lineHeight: 20
    )
    var paragraph = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.regular,
        fontSize: 14,
        lineHeight: 17
    )
    var primaryButton = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.medium,
        fontSize: 24,
        lineHeight: 28
    )
    var secondaryButton = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.regular,
        fontSize: 18,
        lineHeight: 21
    )
    var smallLabel = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.regular,
        fontSize: 10,
        lineHeight: 10
    )
    var largeLabel = FontStyle(
        fontFamily: FontFamily.poppins,
        fontWeight: Font.Weight.semibold,
        fontSize: 14,
        lineHeight: 20
    )
}

extension View {
    func fontStyle(_ fontStyle: FontStyle) -> some View {
        self
            .font(.custom(fontStyle.fontFamily.rawValue, size: CGFloat(fontStyle.fontSize)))
            .fontWeight(fontStyle.fontWeight)
            .lineSpacing(CGFloat(fontStyle.lineHeight - fontStyle.fontSize))
    }
}
