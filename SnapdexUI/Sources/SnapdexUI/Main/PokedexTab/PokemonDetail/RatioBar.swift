import SwiftUI
import SnapdexDesignSystem

struct RatioBar : View {
    let ratio: Double
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 6) {
            Rectangle()
                .fill(theme.colors.primary)
                .frame(height: 8)
                .overlay {
                    GeometryReader { geo in
                        let width = geo.size.width * ratio
                        Rectangle()
                            .fill(theme.colors.secondary)
                            .frame(width: width, alignment: .leading)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 49))
            
            HStack {
                HStack(spacing: 4) {
                    Image("Male", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                    
                    
                    Text(ratio.formatted(.percent))
                        .fontStyle(theme.typography.smallLabel)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("Female", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                    
                    Text((1.0 - ratio).formatted(.percent))
                        .fontStyle(theme.typography.smallLabel)
                }
            }
        }
    }
}

#Preview {
    AppTheme {
        RatioBar(ratio: 0.875)
            .padding(.horizontal, 16)
    }
}
