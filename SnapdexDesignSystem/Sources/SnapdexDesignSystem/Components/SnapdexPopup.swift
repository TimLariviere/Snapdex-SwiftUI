import SwiftUI

public struct PopupButton {
    let text: LocalizedStringKey
    let onClick: @MainActor () -> Void
    let enabled: Bool
    let isBusy: Bool
    
    public init(text: LocalizedStringKey, enabled: Bool = true, isBusy: Bool = false, onClick: @MainActor @escaping () -> Void) {
        self.text = text
        self.enabled = enabled
        self.isBusy = isBusy
        self.onClick = onClick
    }
}

public struct SnapdexPopup: View {
    let title: String
    let description: String
    let primaryButton: PopupButton
    let secondaryButton: PopupButton?
    let onDismiss: () -> Void
    
    @Environment(\.theme) private var theme
    
    public init(title: String, description: String, onDismiss: @escaping () -> Void, primaryButton: PopupButton, secondaryButton: PopupButton? = nil) {
        self.title = title
        self.description = description
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            theme.colors.shadow
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
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
