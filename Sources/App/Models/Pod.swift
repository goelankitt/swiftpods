import Vapor
import FluentPostgreSQL

final class Pod: Codable {
    var id: Int?
    var name: String
    var url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

extension Pod: PostgreSQLModel {}
extension Pod: Content {}
extension Pod: Parameter {}

extension Pod: Migration {
    static func prepare(on connection: PostgreSQLConnection)
        -> Future<Void> {
            return Database.create(self, on: connection) { builder in
                try addProperties(to: builder)
                builder.unique(on: \.url)
            }
    }
}

