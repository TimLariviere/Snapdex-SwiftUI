import SwiftUI

struct OutlineStrokeModifier: ViewModifier {
    let strokeSize: CGFloat
    let strokeColor: Color?
    
    @Environment(\.theme) private var theme
    
    init(strokeSize: CGFloat = 1, strokeColor: Color? = nil) {
        self.strokeSize = strokeSize
        self.strokeColor = strokeColor
    }

    func body(content: Content) -> some View {
        content
            .padding(strokeSize)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor ?? theme.colors.outline)
                    .mask(outline(context: content))
            )
    }

    private func outline(context: Content) -> some View {
        let outline = "outline"
        
        return Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: outline) {
                    layer.draw(text, at: CGPoint(x: size.width / 2, y: size.height / 2))
                }
            }
        } symbols: {
            context.tag(outline).blur(radius: strokeSize / 4.0)
        }
    }
}

extension View {
    public func outlineStroke(width: CGFloat) -> some View {
        self.modifier(OutlineStrokeModifier(strokeSize: width, strokeColor: nil))
    }
    public func outlineStroke(color: Color, width: CGFloat) -> some View {
        self.modifier(OutlineStrokeModifier(strokeSize: width, strokeColor: color))
    }
}

#Preview {
    AppTheme {
        Text("Hello, world!")
            .outlineStroke(width: 2)
            .foregroundStyle(.white)
            
    }
}
