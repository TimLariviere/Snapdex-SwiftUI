public struct Synced<T: Sendable> : Sendable {
    public let value: T
    public let createdAt: UInt64
    public let updatedAt: UInt64
    
    public init(value: T, createdAt: UInt64, updatedAt: UInt64) {
        self.value = value
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
