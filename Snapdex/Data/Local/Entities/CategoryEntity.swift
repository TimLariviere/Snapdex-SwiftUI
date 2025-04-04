import GRDB

struct CategoryEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    
    static let databaseTableName: String = "Categories"
}

struct CategoryTranslationEntity: Codable, FetchableRecord, TableRecord, Identifiable {
    var id: Int
    var categoryId: Int
    var language: String
    var name: String
    
    static let databaseTableName: String = "CategoryTranslations"
    
    enum Columns: String, ColumnExpression {
        case categoryId
    }
}
