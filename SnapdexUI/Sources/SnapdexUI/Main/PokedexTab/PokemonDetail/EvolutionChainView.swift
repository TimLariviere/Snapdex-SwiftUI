import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct EvolutionChainView : View {
    let evolutionChain: EvolutionChain
    let onPokemonClick: (PokemonId) -> Void
    @State private var animationStep = 0
    
    var body: some View {
        VStack(spacing: 16) {
            PokemonRow(pokemon: evolutionChain.startingPokemon)
                .onTapGesture {
                    onPokemonClick(evolutionChain.startingPokemon.id)
                }
            
            let sorted = evolutionChain.evolutions.sorted(by: { $0.key < $1.key })
            let links = Array(sorted.enumerated())
            ForEach(links, id: \.offset) { index, link in
                VStack(spacing: -24) {
                    let animateCurrentRow = animationStep / 2 == index
                    let animateArrow1 = animateCurrentRow && (animationStep % 2 == 0)
                    let animateArrow2 = animateCurrentRow && (animationStep % 2 == 1)
                    
                    LevelRow(
                        level: link.key,
                        animateArrow1: animateArrow1,
                        animateArrow2: animateArrow2
                    )
                    
                    PokemonRow(pokemon: link.value)
                        .onTapGesture {
                            onPokemonClick(link.value.id)
                        }
                }
            }
        }
        .onAppear {
            animateArrows()
        }
    }
    
    private func animateArrows() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            Task { @MainActor in
                animationStep = (animationStep + 1) % (evolutionChain.evolutions.count * 2)
            }
        }
    }
}

struct PokemonRow : View {
    let pokemon: Pokemon
    
    @Environment(\.theme) private var theme
    @Environment(\.locale) private var locale
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(String(format: "Nº%04d", pokemon.id))
                        .fontStyle(theme.typography.smallLabel)
                    
                    Text(pokemon.name.translated(locale))
                        .fontStyle(theme.typography.heading2)
                }
            }
            .frame(height: 76)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 124)
            .background(theme.colors.surface)
            .clipShape(theme.shapes.regular)
            .overlay {
                theme.shapes.regular
                    .stroke(theme.colors.outline, lineWidth: 1)
            }
            
            Image(String(format: "Pokemon%04d", pokemon.id), bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 124)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LevelRow: View {
    let level: Level
    let animateArrow1: Bool
    let animateArrow2: Bool
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: -4) {
                SnapdexIcon(.arrowDown)
                    .foregroundStyle(animateArrow1 ? theme.colors.primary.opacity(0.4) : theme.colors.surface)
                    .animation(.easeInOut(duration: 0.25), value: animateArrow1)
                
                SnapdexIcon(.arrowDown)
                    .foregroundStyle(animateArrow2 ? theme.colors.primary.opacity(0.8) : theme.colors.surface)
                    .animation(.easeInOut(duration: 0.25), value: animateArrow2)
            }
            .frame(width: 40)
            
            Text(String(format: "Level %d", level))
                .fontStyle(theme.typography.largeLabel)
                .foregroundStyle(theme.colors.inOutline)
                .outlineStroke(width: 1)
        }
    }
}

#Preview {
    let evolutionChain =
        EvolutionChain(
            startingPokemon:
                Pokemon(
                    id: 4,
                    name: [ Locale(identifier: "en") : "Charmander" ],
                    description:
                        [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                    types: [ .fire, .flying ],
                    weaknesses: [ .bug ],
                    weight: Measurement(value: 120, unit: .kilograms),
                    height: Measurement(value: 1.7, unit: .meters),
                    category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                    ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                    maleToFemaleRatio: 0.875
                ),
            evolutions:
                [
                    16: Pokemon(
                        id: 5,
                        name: [ Locale(identifier: "en") : "Charmeleon" ],
                        description:
                            [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                        types: [ .fire, .flying ],
                        weaknesses: [ .bug ],
                        weight: Measurement(value: 120, unit: .kilograms),
                        height: Measurement(value: 1.7, unit: .meters),
                        category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                        ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                        maleToFemaleRatio: 0.875
                    ),
                    32: Pokemon(
                        id: 6,
                        name: [ Locale(identifier: "en") : "Charizard" ],
                        description:
                            [ Locale(identifier: "en"): "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade." ],
                        types: [ .fire, .flying ],
                        weaknesses: [ .bug ],
                        weight: Measurement(value: 120, unit: .kilograms),
                        height: Measurement(value: 1.7, unit: .meters),
                        category: PokemonCategory(id: 0, name: [Locale(identifier: "en") : "Lizard" ]),
                        ability: PokemonAbility(id: 0, name: [Locale(identifier: "en") : "Blaze" ]),
                        maleToFemaleRatio: 0.875
                    ),
                ]
        )
    
    AppTheme {
        SnapdexBackground {
            EvolutionChainView(
                evolutionChain: evolutionChain,
                onPokemonClick: { _ in }
            )
        }
    }
}
