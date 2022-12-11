import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "done")
    var done: Bool
    
    init() { }

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.done = false
    }
}
