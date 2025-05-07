import SwiftUI
import SnapdexDesignSystem
import SnapdexDomain

struct StatsScreen: View {
    @Environment(\.theme) private var theme
    @Environment(NavBarVisibility.self) private var navBarVisibility
    @State private var viewModel: StatsViewModel
    
    init(deps: AppDependencies) {
        self._viewModel = State(initialValue: StatsViewModel(deps: deps))
    }
    
    var body: some View {
        SnapdexScaffold {
            ScrollView {
                VStack(spacing: 24) {
                    overallProgress
                    progressByType
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 64)
            }
        }
        .onAppear {
            navBarVisibility.isVisible = true
        }
    }
    
    var overallProgress: some View {
        let completionRate = Double(viewModel.overallCompletion.caughtPokemonCount) / Double(viewModel.overallCompletion.totalPokemonCount)
        let completionRateInt = Int(completionRate * 100)
        
        return VStack(spacing: 8) {
            Text("Completion")
                .fontStyle(theme.typography.heading3)
            
            Text(String(format: "%d%%", completionRateInt))
                .fontStyle(theme.typography.heading1)
            
            SnapdexLinearGraph(progress: completionRate)
                .frame(height: 16)
            
            Text(String(format: "%d/%d pokemons captured", viewModel.overallCompletion.caughtPokemonCount, viewModel.overallCompletion.totalPokemonCount))
        }
        .padding(16)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.regular)
    }
    
    var progressByType: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
            ForEach(PokemonType.allCases, id: \.self) {
                let typeUi = TypeUi.fromType($0)
                typeProgress(typeUi: typeUi, statistic: viewModel.completionByType[$0]!)
            }
        }
    }
    
    func typeProgress(typeUi: TypeUi, statistic: Statistic) -> some View {
        let completionRate = Double(viewModel.overallCompletion.caughtPokemonCount) / Double(viewModel.overallCompletion.totalPokemonCount)
        let completionRateInt = Int(completionRate * 100)
        
        return VStack(spacing: 8) {
            HStack(spacing: 8) {
                typeUi.image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(typeUi.color)
                    .frame(width: 24, height: 24)
                
                Text(typeUi.name)
                    .fontStyle(theme.typography.largeLabel)
            }
            
            ZStack {
                SnapdexCircleGraph(progress: completionRate, width: 16)
                
                Text(String(format: "%d%%", completionRateInt))
                    .fontStyle(theme.typography.largeLabel.withSize(16))
            }
            .frame(maxHeight: .infinity)
            
            Text(String(format: "%d/%d captured", statistic.caughtPokemonCount, statistic.totalPokemonCount))
                .fontStyle(theme.typography.smallLabel)
        }
        .padding(8)
        .frame(minWidth: 160, maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(theme.colors.surface)
        .clipShape(theme.shapes.regular)
    }
}

#Preview {
    AppTheme {
        StatsScreen(deps: MockAppDependencies.shared)
            .environment(NavBarVisibility())
    }
}
