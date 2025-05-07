import SwiftUI
import Combine
import SnapdexDomain

@Observable final class StatsViewModel {
    var overallCompletion = Statistic(totalPokemonCount: 1, caughtPokemonCount: 0)
    var completionByType = PokemonType.allCases.associate { type in
        (type, Statistic(totalPokemonCount: 1, caughtPokemonCount: 0))
    }
    
    @ObservationIgnored private var cancellable: AnyCancellable?
    
    init(deps: AppDependencies) {
        self.cancellable = deps.authServicing.getCurrentUserPublisher()
            .compactMap { $0?.id }
            .flatMap { userId -> AnyPublisher<(Statistic, [PokemonType: Statistic]), Never> in
                let overall = deps.statisticsServicing.getCompletionRate(userId: userId)
                let byType = deps.statisticsServicing.getCompletionRateByType(userId: userId)
                return Publishers.Zip(overall, byType)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] overallCompletion, completionByType in
                self?.overallCompletion = overallCompletion
                self?.completionByType = completionByType
            }
    }
}
