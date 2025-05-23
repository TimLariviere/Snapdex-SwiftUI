import SwiftUI
import Flow
import SnapdexDesignSystem
import SnapdexDomain

struct PokemonDetailScreen : View {
    @Environment(\.theme) private var theme
    @Environment(\.locale) private var locale
    @Environment(Router<PokedexTabDestination>.self) private var router
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @State private var viewModel: PokemonDetailViewModel
    @State private var types: [TypeUi] = []
    @State private var weaknesses: [TypeUi] = []
    
    init(deps: AppDependencies, pokemonId: PokemonId) {
        self._viewModel = State(initialValue: PokemonDetailViewModel(deps: deps, pokemonId: pokemonId))
    }
    
    var body: some View {
        SnapdexScaffold(title: "") {
            if let pokemon = viewModel.pokemon {
                let gifName = String(format: "Pokemon%04d", pokemon.id)
                
                ScrollView {
                    VStack(spacing: 24) {
                        GIFImage(gifName: gifName, bundle: .module)
                            .frame(height: 180)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        header(pokemon: pokemon)
                            .frame(maxWidth: .infinity)
                        
                        HFlow(spacing: 8) {
                            ForEach(Array(types.enumerated()), id: \.offset) { _, type in
                                TypeTag(typeUi: type)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                        Text(pokemon.description.translated(locale))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        
                        dataCards(pokemon: pokemon)
                            .frame(maxWidth: .infinity)
                        
                        weaknessesSection
                            .frame(maxWidth: .infinity)
                        
                        if let evolutionChain = viewModel.evolutionChain {
                            evolutionsSection(evolutionChain: evolutionChain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            } else {
                Text("Loading")
                    .frame(maxHeight: .infinity)
            }
        }
        .onAppear {
            navBarVisibility.isVisible = false
            Task {
                await viewModel.loadPokemon()
            }
        }
        .onChange(of: viewModel.pokemon) { old, new in
            if let pokemon = new {
                types = pokemon.types.map { TypeUi.fromType($0) }
                weaknesses = pokemon.weaknesses.map { TypeUi.fromType($0) }
            } else {
                types = []
                weaknesses = []
            }
        }
    }
    
    func header(pokemon: Pokemon) -> some View {
        VStack(alignment: .leading) {
            Text(String(format: "Nº%04d", pokemon.id))
                .fontStyle(theme.typography.smallLabel)
            
            Text(pokemon.name.translated(locale))
                .fontStyle(theme.typography.heading1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func dataCards(pokemon: Pokemon) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                DataCardItem(icon: "Weight", name: "Weight", value: pokemon.weight.formatted())
                DataCardItem(icon: "Height", name: "Height", value: pokemon.height.formatted())
            }
            HStack(spacing: 8) {
                DataCardItem(icon: "Category", name: "Category", value: pokemon.category.name.translated(locale))
                DataCardItem(icon: "Pokeball", name: "Abilities", value: pokemon.ability.name.translated(locale))
            }
            
            VStack {
                Text("Gender".uppercased())
                    .fontStyle(theme.typography.largeLabel)
                
                RatioBar(ratio: pokemon.maleToFemaleRatio)
            }
        }
    }
    
    var weaknessesSection: some View {
        VStack(alignment: .leading) {
            Text("Weaknesses".uppercased())
                .fontStyle(theme.typography.largeLabel)
            
            HFlow(spacing: 8) {
                ForEach(Array(weaknesses.enumerated()), id: \.offset) { _, type in
                    TypeTag(typeUi: type)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func evolutionsSection(evolutionChain: EvolutionChain) -> some View {
        VStack(alignment: .leading, spacing: -16) {
            Text("Evolutions".uppercased())
                .fontStyle(theme.typography.largeLabel)
            
            EvolutionChainView(
                evolutionChain: evolutionChain,
                onPokemonClick: { pokemonId in
                    router.push(.pokemonDetail(pokemonId))
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AppTheme {
        PokemonDetailScreen(deps: MockAppDependencies(), pokemonId: 1)
    }
    .environment(Router<PokedexTabDestination>())
    .environment(NavBarVisibility())
}


