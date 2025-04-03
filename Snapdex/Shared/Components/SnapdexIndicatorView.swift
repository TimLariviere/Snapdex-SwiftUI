import SwiftUI

struct SnapdexIndicatorView: View {
    @Environment(\.theme) private var theme
    
    var pageCount: Int
    @Binding var currentPage: Int
    
    init(pageCount: Int, currentPage: Binding<Int>) {
        self.pageCount = pageCount
        self._currentPage = currentPage
    }
    
    var body: some View {
        HStack {
            ForEach(0..<pageCount, id: \.self) { index in
                ZStack {
                    Circle()
                        .fill(currentPage == index ? theme.colors.primary : theme.colors.surface)
                    
                    Circle()
                        .strokeBorder(theme.colors.outline, lineWidth: 1)
                }
                .frame(width: 16, height: 16)
                .onTapGesture {
                    currentPage = index
                }
            }
        }
    }
}

#Preview {
    SnapdexIndicatorView(
        pageCount: 3,
        currentPage: Binding.constant(1)
    )
}
