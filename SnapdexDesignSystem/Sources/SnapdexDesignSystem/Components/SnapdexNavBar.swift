import SwiftUI

public struct TabItem {
    let selected: SnapdexIconName
    let unselected: SnapdexIconName
    
    public init(selected: SnapdexIconName, unselected: SnapdexIconName) {
        self.selected = selected
        self.unselected = unselected
    }
}

public struct SnapdexNavBar : View {
    let tabs: [TabItem]
    @Binding var selected: Int
    
    @Environment(\.theme) private var theme
    private let tabChangeAnimation = Animation.easeIn(duration: 0.1)

    public init(tabs: [TabItem], selected: Binding<Int>) {
        self.tabs = tabs
        self._selected = selected
    }
    
    public var body: some View {
        HStack(spacing: 32) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                let isSelected = index == selected
                SnapdexIcon(isSelected ? tab.selected : tab.unselected)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.navBarOnBackground)
                    .onTapGesture {
                        selected = index
                    }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 8)
        .background(theme.colors.navBarBackground)
        .clipShape(theme.shapes.navBar)
        .overlay {
            GeometryReader { geo in
                let leadingWeight = calculate(width: geo.size.width)
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .fill(theme.colors.primary)
                        .frame(height: 4)
                        .clipShape(theme.shapes.navBarIndicator)
                }
                .frame(width: 40)
                .padding(.leading, leadingWeight)
                .animation(tabChangeAnimation, value: selected)
            }
            .padding(.horizontal, 36)
        }
    }
    
    func calculate(width: Double) -> Double {
        switch (selected) {
            case 1: return width / 2.0 - 20.0
            case 2: return width - 40.0
            default: return 0.0
        }
    }
}

#Preview {
    AppTheme {
        SnapdexBackground {
            SnapdexNavBar(
                tabs: [
                    TabItem(selected: .gridSelected, unselected: .gridUnselected),
                    TabItem(selected: .statsSelected, unselected: .statsUnselected),
                    TabItem(selected: .profileSelected, unselected: .profileUnselected)
                ],
                selected: .constant(0)
            )
        }
    }
}
