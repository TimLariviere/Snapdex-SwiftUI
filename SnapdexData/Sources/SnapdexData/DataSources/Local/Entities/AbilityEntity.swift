import GRDB

public struct AbilityEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    
    public static let databaseTableName: String = "Abilities"
    public static let translations = hasMany(AbilityTranslationEntity.self)
}

public struct AbilityTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    public var abilityId: Int
    public var language: String
    public var name: String
    
    public static let databaseTableName: String = "AbilityTranslations"
    
    enum Columns: String, ColumnExpression {
        case abilityId
    }
}
