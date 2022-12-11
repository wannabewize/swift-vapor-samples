// Todo Model

import Vapor

var todos: [Todo] = []

struct Todo: Codable {
    var id = UUID()
    var title: String
    var done: Bool = false
}

extension Todo: Content {
    
}
