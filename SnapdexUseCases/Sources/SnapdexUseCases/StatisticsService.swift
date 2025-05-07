import Combine
import Foundation
import SnapdexDomain

public protocol StatisticsServicing: Sendable {
    func getCompletionRate(userId: UserId) -> AnyPublisher<Statistic, Never>
    func getCompletionRateByType(userId: UserId) -> AnyPublisher<[PokemonType: Statistic], Never>
}

public final class StatisticsService: StatisticsServicing {
    private let crashReporter: CrashReporter
    private let localStatistics: LocalStatisticsDataSource
    
    public init(crashReporter: CrashReporter, localStatistics: LocalStatisticsDataSource) {
        self.crashReporter = crashReporter
        self.localStatistics = localStatistics
    }
    
    public func getCompletionRate(userId: UserId) -> AnyPublisher<Statistic, Never> {
        localStatistics.getCompletionRate(userId: userId)
            .catch { error -> AnyPublisher<Statistic, Never> in
                self.crashReporter.recordException(error: error, metadata: ["userId": userId])
                return Just(Statistic(totalPokemonCount: 0, caughtPokemonCount: 0)).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func getCompletionRateByType(userId: UserId) -> AnyPublisher<[PokemonType : Statistic], Never> {
        localStatistics.getCompletionRateByType(userId: userId)
            .catch { error -> AnyPublisher<[StatisticByType], Never> in
                self.crashReporter.recordException(error: error, metadata: ["userId": userId])
                return Just([StatisticByType]()).eraseToAnyPublisher()
            }
            .map { statisticsByType in
                PokemonType.allCases.associate { type in
                    let statistic = statisticsByType.first(where: { $0.type == type })!.statistic
                    return (type, statistic)
                }
            }
            .eraseToAnyPublisher()
    }
}

