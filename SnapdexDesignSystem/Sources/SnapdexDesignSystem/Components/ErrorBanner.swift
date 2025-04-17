import SwiftUI

public struct ErrorBanner: View {
    let errorMessage: String?
    
    @Environment(\.theme) private var theme
    
    public init(_ errorMessage: String?) {
        self.errorMessage = errorMessage
    }
    
    public var body: some View {
        ZStack {
            if let errorMessage = errorMessage {
                HStack(spacing: 4) {
                    Image("Error")
                        .resizable()
                        .scaledToFit()
                    
                    Text(errorMessage)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .foregroundStyle(theme.colors.error)
                .background(theme.colors.error.opacity(0.1))
                .overlay {
                    theme.shapes.regular
                        .stroke(theme.colors.error, lineWidth: 1)
                }
                .clipShape(theme.shapes.regular)
            } else {
                EmptyView()
            }
        }
        .frame(height: 32)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PreviewView {
        ErrorBanner(nil)
        ErrorBanner("Invalid error")
    }
}
