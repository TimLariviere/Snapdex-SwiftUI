import GRDB
import Foundation

public final class SnapdexDatabase: @unchecked Sendable {
    var dbQueue: DatabaseQueue!
    
    public init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        guard let bundledDbURL = Bundle.main.url(forResource: "snapdex", withExtension: "db") else {
            fatalError("Missing bundled database in app resources.")
        }
        
        let fileManager = FileManager.default
        let destinationURL = try! fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("snapdex.db")
        
        if !fileManager.fileExists(atPath: destinationURL.path) {
            do {
                try fileManager.copyItem(at: bundledDbURL, to: destinationURL)
                print("Copied bundled database to Documents folder.")
            } catch {
                fatalError("Error copying database: \(error)")
            }
        } else {
            print("Database already exists at destination.")
        }
        
        var config = Configuration()
        config.foreignKeysEnabled = true
        dbQueue = try! DatabaseQueue(path: destinationURL.path, configuration: config)
    }
}
