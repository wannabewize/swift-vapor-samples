//
//  File.swift
//  
//
//  Created by wannabewize on 2022/12/11.
//

import Vapor

struct CommonResponse<T: Content>: Content {
    var data: T
}

struct TodoAddRequest: Content {
    var todo: String
}

class TodoController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.delete(":id", use: delete)
        todos.patch(":id", use: toggleDone)
    }
    
    func delete(req: Request) throws -> CommonResponse<Todo> {
        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        if let deleted = TodoManager.shared.deleteTodo(id: id) {
            return CommonResponse(data: deleted)
        }
        
        throw Abort(.notFound)
    }
    
    func toggleDone(req: Request) throws -> CommonResponse<Todo> {
        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        if let updated = TodoManager.shared.toggleTodo(id: id) {
            return CommonResponse(data: updated)
        }
        throw Abort(.notFound)
    }
    
    func index(req: Request) throws -> CommonResponse<[Todo]> {        
        return CommonResponse(data: TodoManager.shared.todos)
    }
    
    func create(req: Request) throws -> Todo {
        do {
            let body = try req.content.decode(TodoAddRequest.self)
            let title = body.todo
            let newTodo = Todo(title: title)
            TodoManager.shared.addTodo(newTodo)
            return newTodo
        }
        catch {
            throw Abort(.badRequest)
        }
    }
}
