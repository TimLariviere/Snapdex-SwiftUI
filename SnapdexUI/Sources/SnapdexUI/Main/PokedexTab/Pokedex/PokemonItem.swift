import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct PokemonItem: View {
    let pokemon: Pokemon
    
    @Environment(\.theme) private var theme
        
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Spacer()
                ForEach(pokemon.types, id: \.self) { type in
                    SmallTypeBadge(typeUi: TypeUi.fromType(type))
                }
            }
            
            VStack(spacing: 4) {
                Image(String(format: "Pokemon%04d", pokemon.id), bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: .infinity)
                
                Text(String(format: "%04d", pokemon.id))
            }
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
