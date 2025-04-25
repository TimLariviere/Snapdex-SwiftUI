import UIKit
import SwiftUI

public struct SnapdexOutlinedText: UIViewRepresentable {
    var text: String
    var textColor: Color? = nil
    var outlineColor: Color? = nil
    var outlineWidth: Double? = nil
    
    @Environment(\.theme) private var theme
    @Environment(\.fontStyle) private var fontStyle
    
    public init(_ text: String, textColor: Color? = nil, outlineColor: Color? = nil, outlineWidth: Double? = nil) {
        self.text = text
        self.textColor = textColor
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
    }
    
    public func makeUIView(context: Context) -> UILabel {
        let textColor = UIColor(textColor ?? theme.colors.inOutline)
        let outlineColor = UIColor(outlineColor ?? theme.colors.outline)
        let outlineWidth = outlineWidth != nil ? CGFloat(outlineWidth!) : CGFloat(1)
        let font = UIFont(name: fontStyle.fontFamily.rawValue, size: CGFloat(fontStyle.fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontStyle.fontSize))
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .strokeColor: outlineColor,
            .strokeWidth: -outlineWidth // Negative value creates outlined text with fill
        ]
        
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        return label
    }
    
    public func updateUIView(_ uiView: UILabel, context: Context) {
    }
}

#Preview {
    AppTheme {
        SnapdexBackground {
            SnapdexOutlinedText("Hello, world!")
            .fontStyle(Theme().typography.heading1)
        }
    }
}
