import SwiftUI

public struct SnapdexLinearGraph: View {
    @Environment(\.theme) private var theme
    private let progress: Double
    
    public init(progress: Double) {
        self.progress = progress
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 26)
            .fill(theme.colors.statsFill)
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    let roundedProgress = Double(progress * 100).rounded() / 100.0
                    let width = geo.size.width * roundedProgress
                    
                    RoundedRectangle(cornerRadius: 22)
                        .fill(theme.colors.primary)
                        .padding(4)
                        .frame(width: width)
                }
            }
    }
}

#Preview {
    AppTheme {
        VStack {
            SnapdexLinearGraph(progress: 0.0)
                .frame(height: 32)
            
            SnapdexLinearGraph(progress: 0.25)
                .frame(height: 32)
            
            SnapdexLinearGraph(progress: 0.50)
                .frame(height: 32)
            
            SnapdexLinearGraph(progress: 0.75)
                .frame(height: 32)
            
            SnapdexLinearGraph(progress: 1.0)
                .frame(height: 32)
        }
        .padding(.horizontal, 16)
    }
}
