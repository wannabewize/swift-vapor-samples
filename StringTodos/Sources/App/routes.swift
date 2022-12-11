import Vapor

struct TodosResponse: Content, Decodable {
    var data: [String]
}

struct TodoPostReqBody: Content {
    var todo: String
}

var todos: [String] = ["ios", "swift"]

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("todos") { req -> TodosResponse in
        return TodosResponse(data: todos)
    }
    
    app.post("todos") { req -> TodosResponse in
        do {
            let body = try req.content.decode(TodoPostReqBody.self)
            todos.append(body.todo)
            return TodosResponse(data: todos)
        }
        catch {
            throw Abort(.badRequest)
        }
    }
    
    app.get("todosString") { req -> String in
        let res = todos.joined(separator: ",")
        return res
    }
    
    app.get("todosHtml") { req -> String in
        return """
        <html>
        <body>
            <h1>Todos</h1>
            \(todos.map({ item in "<li>\(item)</li>"}) .joined())
        </body>
        </html>
        """
    }
    
    app.get("todosHtml2") { req -> Response in
        let headers = HTTPHeaders([("Content-Type","text/html")])
        let bodyStr = """
        <html>
        <body>
            <h1>Todos</h1>
            \(todos.map({ item in "<li>\(item)</li>"}) .joined())
        </body>
        </html>
        """
        let body = Response.Body(string: bodyStr)
        let res = Response(status: .ok, version: .http1_1, headersNoUpdate: headers, body: body)
        return res
    }
}
