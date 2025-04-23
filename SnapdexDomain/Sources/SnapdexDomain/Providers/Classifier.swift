public protocol Classifier: Sendable {
    func initialize() async
    func classify(bitmap: [UInt8]) async -> PokemonId?
}
