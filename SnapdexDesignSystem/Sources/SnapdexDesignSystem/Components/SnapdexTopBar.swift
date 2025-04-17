import SwiftUI

public struct SnapdexTopBar: View {
    let title: LocalizedStringKey
    
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    
    public init(title: LocalizedStringKey) {
        self.title = title
    }
    
    public var body: some View {
        ZStack {
            Text(title)
                .fontStyle(theme.typography.heading2)
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            .frame(width: 24, height: 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }
}


#Preview {
    AppTheme {
        SnapdexTopBar(title: "Forgotten Password")
    }
}
