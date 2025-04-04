import GRDB

struct AbilityEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    
    static let databaseTableName: String = "Abilities"
}

struct AbilityTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var abilityId: Int
    var language: String
    var name: String
    
    static let databaseTableName: String = "AbilityTranslations"
    
    enum Columns: String, ColumnExpression {
        case abilityId
    }
}
