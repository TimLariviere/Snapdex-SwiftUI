import SwiftUI

public struct SnapdexLinkButton: View {
    var textKey: LocalizedStringKey
    var enabled: Bool
    var action: () -> Void
    
    public init(_ textKey: LocalizedStringKey, enabled: Bool = true, action: @escaping () -> Void) {
        self.textKey = textKey
        self.enabled = enabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(textKey)
                .underline()
        }
        .disabled(!enabled)
    }
}

#Preview {
    AppTheme {
        SnapdexLinkButton("Link button") {}
    }
}
