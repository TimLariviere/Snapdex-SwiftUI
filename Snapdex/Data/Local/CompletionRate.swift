import GRDB

struct CompletionRate: Decodable, FetchableRecord {
    var totalPokemonCount: Int
    var caughtPokemonCount: Int
}

struct CompletionRateByType: Decodable, FetchableRecord {
    var type: Int
    var totalPokemonCount: Int
    var caughtPokemonCount: Int
}
