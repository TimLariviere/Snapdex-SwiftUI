public struct EvolutionChain {
    public let startingPokemon: Pokemon
    public let evolutions: [Level: Pokemon]
    
    public init(startingPokemon: Pokemon, evolutions: [Level : Pokemon]) {
        self.startingPokemon = startingPokemon
        self.evolutions = evolutions
    }
}
