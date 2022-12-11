import Vapor

struct TodosResponse: Content {
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

    app.get("hello") { req -> String in
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
        return Response(status: .ok, version: .http1_1, headers: headers, body: body)

//        let res = Response(headers: headers, body: body)
//        return res
    }
    
    app.get("todosJson") { req -> Response in
        do {
            let headers = HTTPHeaders([("Content-Type", "application/json")])
            let data = TodosResponse(data: todos)
            let jsonData = try JSONEncoder().encode(data)
            let body = Response.Body(data: jsonData)
            let res = Response(headers: headers, body: body)
            return res
        }
    }
    
    // JSON응답, Content 타입 활용하기
    app.get("todosJson2") { req -> TodosResponse in
        return TodosResponse(data: todos)
    }
    
    app.get("image") { req -> Response in
        do {
            let headers = HTTPHeaders([("Content-Type", "image/jpeg")])
            // Path from Public
            let url = URL(fileURLWithPath: "Public/image1.jpg")
            debugPrint("url :", url)
            let imageData: Data = try Data(contentsOf: url)
            let body = Response.Body(data: imageData)
            return Response(headers: headers, body: body)
        }
        catch {
            throw Abort(.notFound)
        }
    }
    
    app.get("unauthorized") { req -> Response in
        return Response(status: .unauthorized)
    }
    
    app.get("notfound") { req -> Response in
        throw Abort(.notFound)
    }
}
