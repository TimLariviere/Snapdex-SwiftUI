import GRDB

struct EvolutionChainWithRelations: Decodable, FetchableRecord {
    var startingPokemon: PokemonWithRelations
    var evolvesTo: [EvolutionChainLinkWithRelations]
}

struct EvolutionChainLinkWithRelations: Decodable, FetchableRecord {
    var pokemon: PokemonWithRelations
    var minLevel: Int
}
