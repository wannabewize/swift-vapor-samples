// Todo Model

import Vapor

struct Todo: Content {
    var id = UUID()
    var title: String
    var done: Bool = false
}

struct TodoManager {
    static var shared = TodoManager()
    var todos: [Todo] = []
    
    mutating func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    mutating func toggleTodo(id: String) -> Todo? {
        let todoId = UUID(uuidString: id)        
        for i in (0..<todos.count) {
            if todos[i].id == todoId {
                todos[i].done = !todos[i].done
                return todos[i]
            }
        }
        return nil
    }
    
    mutating func deleteTodo(id: String) -> Todo? {
        let todoId = UUID(uuidString: id)
        for i in (0..<todos.count) {
            if todos[i].id == todoId {
                let deleted = todos.remove(at: i)
                return deleted
            }
        }
        return nil
    }
}
