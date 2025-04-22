import Foundation

public struct PokemonCategory {
    public let id: Int
    public let name: [Locale: String]
    
    public init(id: Int, name: [Locale : String]) {
        self.id = id
        self.name = name
    }
}
