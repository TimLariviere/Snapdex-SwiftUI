public protocol CrashReporter : Sendable {
    func recordException(error: Error, metadata: [String: String]?)
}
