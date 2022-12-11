//
//  UpdateDone.swift

import Fluent

struct UpdateDone: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todos")
            .field("done", .bool, .sql(.default(false)))
            .update()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("todos")
            .field("done", .bool, .required)
            .delete()
    }
}
