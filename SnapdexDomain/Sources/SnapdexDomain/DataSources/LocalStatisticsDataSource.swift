import Combine

public protocol LocalStatisticsDataSource : Sendable {
    func getCompletionRate(userId: UserId) -> AnyPublisher<Statistic, Error>
    func getCompletionRateByType(userId: UserId) -> AnyPublisher<[StatisticByType], Error>
}
