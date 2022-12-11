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
        todos.get(use: sendTodos)
        todos.post(use: addTodo)
    }
    
    func sendTodos(req: Request) throws -> CommonResponse<[Todo]> {
        return CommonResponse(data: todos)
    }
    
    func addTodo(req: Request) throws -> Todo {
        do {
            let body = try req.content.decode(TodoAddRequest.self)
            let title = body.todo
            let newTodo = Todo(title: title)
            todos.append(newTodo)
            return newTodo
        }
        catch {
            throw Abort(.badRequest)
        }
    }
}
