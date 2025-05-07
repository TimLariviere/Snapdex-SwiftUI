import SwiftUI

public struct SnapdexCircleGraph: View {
    @Environment(\.theme) private var theme
    private let progress: Double
    private let width: Int
    private let borderWidth: Int
    
    public init(progress: Double, width: Int = 32, borderWidth: Int = 4) {
        self.progress = progress
        self.width = width
        self.borderWidth = borderWidth
    }
    
    public var body: some View {
        Circle()
            .stroke(theme.colors.statsFill, lineWidth: CGFloat(width + borderWidth))
            .overlay {
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        theme.colors.primary,
                        style: StrokeStyle(
                            lineWidth: CGFloat(width - borderWidth),
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .rotationEffect(.degrees(180))
            }
            .padding(CGFloat((width + borderWidth) / 2))
    }
}

#Preview {
    AppTheme {
        VStack(spacing: 30) {
            SnapdexCircleGraph(progress: 0.0, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
            
            SnapdexCircleGraph(progress: 0.10, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
            
            SnapdexCircleGraph(progress: 0.25, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
            
            SnapdexCircleGraph(progress: 0.50, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
            
            SnapdexCircleGraph(progress: 0.75, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
            
            SnapdexCircleGraph(progress: 1.0, width: 16, borderWidth: 4)
                .frame(width: 60, height: 80)
        }
        .padding(.horizontal, 16)
    }
}
