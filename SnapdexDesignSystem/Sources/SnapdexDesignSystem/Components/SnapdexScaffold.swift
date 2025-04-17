import SwiftUI

public struct SnapdexScaffold<Content: View>: View {
    let title: LocalizedStringKey?
    let content: () -> Content
    
    public init(title: LocalizedStringKey? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        SnapdexBackground {
            VStack(spacing: 0) {
                if let title = title {
                    SnapdexTopBar(title: title)
                }
                
                content()
            }
        }
        .toolbar(.hidden)
    }
}
