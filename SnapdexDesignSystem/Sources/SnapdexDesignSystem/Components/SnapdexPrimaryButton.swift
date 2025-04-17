import SwiftUI

public struct SnapdexPrimaryButton: View {
    @Environment(\.theme) private var theme
    var text: LocalizedStringKey
    var enabled: Bool = true
    var isBusy: Bool = false
    var action: () -> Void

    public init(
        _ text: LocalizedStringKey,
        enabled: Bool = true,
        isBusy: Bool = false,
        action: @Sendable @escaping () -> Void
    ) {
        self.text = text
        self.enabled = enabled
        self.isBusy = isBusy
        self.action = action
    }

    public var body: some View {
        Button {
            if enabled && !isBusy {
                action()
            }
        } label: {
            ZStack {
                Text(text)
                    .opacity(isBusy ? 0.0 : 1.0)
                
                SnapdexProgressView()
                    .opacity(isBusy ? 1.0 : 0.0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(enabled ? theme.colors.primary : theme.colors.onSurface.opacity(0.12))
            .foregroundStyle(enabled ? theme.colors.onPrimary : theme.colors.onSurface.opacity(0.38))
            .clipShape(theme.shapes.regular)
        }
    }
}


#Preview {
    let theme = Theme()
    Group {
        SnapdexPrimaryButton("Click me") {}
        SnapdexPrimaryButton("Click me", enabled: false) {}
        SnapdexPrimaryButton("Click me", enabled: false, isBusy: true) {}
    }
    .foregroundStyle(theme.colors.onBackground)
    .fontStyle(theme.typography.paragraph)
}
