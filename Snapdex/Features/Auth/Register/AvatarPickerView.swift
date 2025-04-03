import SwiftUI

struct AvatarPickerView: View {
    @Environment(\.theme) private var theme
    
    @State private var selectedIndex: Int
    private let onAvatarPick: (Int) -> Void
    
    init(selectedIndex: Int, onAvatarPick: @escaping (Int) -> Void) {
        self.selectedIndex = selectedIndex
        self.onAvatarPick = onAvatarPick
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Pick your avatar")
                .fontStyle(theme.typography.heading3)
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<10, id: \.self) { index in
                    let isSelected = index == selectedIndex
                    
                    AvatarImage(id: index)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(width: 90, height: 90)
                        .background(theme.colors.surface)
                        .overlay {
                            Circle()
                                .stroke(
                                    isSelected ? theme.colors.primary : theme.colors.outline,
                                    lineWidth: 1
                                )
                        }
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
            
            Spacer()
            
            SnapdexPrimaryButton(
                "Use Avatar",
                enabled: selectedIndex > -1
            ) {
                onAvatarPick(selectedIndex)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .frame(maxHeight: .infinity)
        .background(theme.colors.surfaceVariant)
    }
}

#Preview {
    PreviewView {
        AvatarPickerView(
            selectedIndex: 1,
            onAvatarPick: { _ in }
        )
    }
}
