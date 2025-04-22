import SwiftUI
import SnapdexDesignSystem

public struct PokedexScreen: View {
    @State private var search: String = ""
    
    public init() {}
    
    public var body: some View {
        SnapdexScaffold {
            VStack {
                SearchView(text: $search, hint: "Search Pokémon...")
                    .padding(.horizontal, 16)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                        ForEach(0..<151, id: \.self) { index in
                            UnknownItem(id: index + 1)
                                .aspectRatio(4.0/5.0, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct UnknownItem: View {
    let id: Int
    
    @Environment(\.theme) private var theme
        
    var body: some View {
        VStack(spacing: 4) {
            Text("?")
                .fontStyle(theme.typography.heading1)
                .outlineStroke(width: 4)
                .foregroundStyle(theme.colors.surface)
                .frame(maxHeight: .infinity)
            
            Text(String(format: "%04d", id))
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 8)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.regular)
        .overlay {
            theme.shapes.regular
                .stroke(theme.colors.outline, lineWidth: 1)
        }
    }
}


#Preview {
    AppTheme {
        PokedexScreen()
    }
}
