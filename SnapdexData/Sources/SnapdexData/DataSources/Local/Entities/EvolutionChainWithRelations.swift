import GRDB

struct EvolutionChainWithRelations: Decodable, FetchableRecord {
    var startingPokemon: PokemonWithRelations
    var evolvesTo: [EvolutionChainLinkWithRelations]
}

struct EvolutionChainLinkWithRelations: Decodable, FetchableRecord {
    var pokemon: PokemonWithRelations
    var minLevel: Int
}

extension EvolutionChainWithRelations {
    public init(row: Row) {
        for key in row.prefetchedRows.keys {
            print("-> Key = \(key)")
        }
        
        print(row.debugDescription)
        startingPokemon = PokemonWithRelations(row: row)
        evolvesTo = row.prefetchedRows["EvolutionChainLinks"]!.map { EvolutionChainLinkWithRelations(row: $0) }
    }
}

extension EvolutionChainLinkWithRelations {
    public init(row: Row) {
        pokemon = PokemonWithRelations(row: row)
        minLevel = 0
    }
}
