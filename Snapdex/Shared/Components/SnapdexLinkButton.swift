import SwiftUI

struct SnapdexLinkButton: View {
    var textKey: LocalizedStringKey
    var enabled: Bool
    var action: () -> Void
    
    init(_ textKey: LocalizedStringKey, enabled: Bool = true, action: @escaping () -> Void) {
        self.textKey = textKey
        self.enabled = enabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(textKey)
                .underline()
        }
        .disabled(!enabled)
    }
}

#Preview {
    PreviewView {
        SnapdexLinkButton("Link button") {}
    }
}
