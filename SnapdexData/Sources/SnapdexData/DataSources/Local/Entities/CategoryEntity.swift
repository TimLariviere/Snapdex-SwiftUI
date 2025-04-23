import GRDB

public struct CategoryEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    
    public static let databaseTableName: String = "Categories"
    public static let translations = hasMany(CategoryTranslationEntity.self)
}

public struct CategoryTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable, Sendable {
    public var id: Int
    public var categoryId: Int
    public var language: String
    public var name: String
    
    public static let databaseTableName: String = "CategoryTranslations"
    
    enum Columns: String, ColumnExpression {
        case categoryId
    }
}
