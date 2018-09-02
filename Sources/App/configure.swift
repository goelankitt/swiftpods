import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let databaseName: String
    let databasePort: Int
    let username = "podsdb"
    let password = "podsdb123"
    if (env == .testing) {
        databaseName = "podsdb-test"
        databasePort = 5433
    } else {
        databaseName = Environment.get("DATABASE_DB") ?? "podsdb"
        databasePort = 5432
    }
    
    var databases = DatabasesConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: "localhost",
        port: databasePort,
        username: username,
        database: databaseName,
        password: password)
    
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Pod.self, database: .psql)
    services.register(migrations)
}
