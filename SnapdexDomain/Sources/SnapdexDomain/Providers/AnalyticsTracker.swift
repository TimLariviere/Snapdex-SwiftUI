public protocol AnalyticsTracker : Sendable {
    func setUserId(userId: UserId?)
    func logEvent(name: String, parameters: [String: String]?)
}
