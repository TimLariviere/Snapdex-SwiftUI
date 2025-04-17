import SwiftUI

public struct SnapdexCarousel<Content: View>: View {
    @Binding var currentPage: Int
    var pageCount: Int
    @ViewBuilder var pageContent: (Int) -> Content
    
    public init(pageCount: Int, currentPage: Binding<Int>, @ViewBuilder pageContent: @escaping (Int) -> Content) {
        self._currentPage = currentPage
        self.pageCount = pageCount
        self.pageContent = pageContent
    }
    
    public var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<pageCount, id: \.self) { index in
                pageContent(index)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    AppTheme {
        SnapdexCarousel(pageCount: 3, currentPage: Binding.constant(1)) { index in
            Text(index.formatted())
        }
    }
}
