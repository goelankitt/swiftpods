import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    var email: String
    var password: String
    
    init(name: String, username: String, email: String, password: String) {
        self.name = name
        self.username = username
        self.email = email
        self.password = password
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Parameter {}

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection)
        -> Future<Void> {
            return Database.create(self, on: connection) { builder in
                try addProperties(to: builder)
                builder.unique(on: \.username)
                builder.unique(on: \.email)
            }
    }
}
