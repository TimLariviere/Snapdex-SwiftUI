import SwiftUI

public struct SnapdexDialogPicker<T: Equatable, Content: View>: View {
    private let title: LocalizedStringKey
    private let buttonText: LocalizedStringKey
    private let items: [T]
    private let initialItemSelected: T
    private let onItemSelected: (T) -> Void
    private let onDismiss: (() -> Void)?
    private let itemContent: (T) -> Content
    
    @Environment(\.theme) private var theme
    @State private var selected: Int
    
    public init(title: LocalizedStringKey, buttonText: LocalizedStringKey, items: [T], initialItemSelected: T, onItemSelected: @escaping (T) -> Void, onDismiss: @escaping () -> Void, itemContent: @escaping (T) -> Content) {
        self.title = title
        self.buttonText = buttonText
        self.items = items
        self.initialItemSelected = initialItemSelected
        self.onItemSelected = onItemSelected
        self.onDismiss = onDismiss
        self.itemContent = itemContent
        self._selected = State(initialValue: items.firstIndex(of: initialItemSelected) ?? 0)
    }
    
    public var body: some View {
        let array = Array(items.enumerated())
        
        return ZStack {
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
                
                HStack(spacing: 8) {
                    ForEach(array, id: \.offset) { index, item in
                        let isSelected = index == selected
                        itemContent(item)
                            .padding(16)
                            .background(theme.colors.surface)
                            .clipShape(theme.shapes.regular)
                            .overlay {
                                theme.shapes.regular
                                    .stroke(isSelected ? theme.colors.primary : theme.colors.outline)
                                    .opacity(isSelected ? 1.0 : 0.0)
                            }
                            .onTapGesture {
                                selected = index
                            }
                    }
                }
                
                SnapdexPrimaryButton(buttonText) {
                    onItemSelected(items[selected])
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
