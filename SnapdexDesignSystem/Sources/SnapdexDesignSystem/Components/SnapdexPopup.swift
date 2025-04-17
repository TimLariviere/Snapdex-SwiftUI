import SwiftUI

public struct PopupButton {
    let text: LocalizedStringKey
    let onClick: @Sendable () -> Void
    let enabled = true
    let isBusy = false
}

public struct SnapdexPopup: View {
    let title: String
    let description: String
    let primaryButton: PopupButton
    let secondaryButton: PopupButton? = nil
    let onDismiss: (() -> Void)? = nil
    
    @Environment(\.theme) private var theme
    
    public init(title: String, description: String, primaryButton: PopupButton) {
        self.title = title
        self.description = description
        self.primaryButton = primaryButton
    }
    
    public var body: some View {
        ZStack {
            theme.colors.shadow
                .ignoresSafeArea()
                .onTapGesture {
                    if let onDismiss {
                        onDismiss()
                    }
                }
            
            VStack(spacing: 16) {
                Text(title)
                    .fontStyle(theme.typography.heading3)
                
                Text(description)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    SnapdexPrimaryButton(
                        primaryButton.text,
                        enabled: primaryButton.enabled,
                        action: primaryButton.onClick
                    )
                    .frame(maxWidth: .infinity)
                    
                    if let secondaryButton = secondaryButton {
                        SnapdexSecondaryButton(
                            secondaryButton.text,
                            enabled: secondaryButton.enabled,
                            action: secondaryButton.onClick
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .background(theme.colors.surfaceVariant)
            .clipShape(theme.shapes.small)
            .padding(20)
        }
    }
}
