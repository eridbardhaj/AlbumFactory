import RealmSwift

enum RealmMigrator {
    static private func migrationBlock(
        migration: Migration,
        oldSchemaVersion: UInt64
    ) {}

    static func setDefaultConfiguration() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: migrationBlock
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
}


