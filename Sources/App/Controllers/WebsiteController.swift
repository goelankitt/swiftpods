import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("list", use: listHandler)
        router.get("pods", Pod.parameter, use: podHandler)
        router.get("add", use: addPodHandler)
        router.post(Pod.self, at: "add", use: addPodPostHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        return Pod.query(on: req)
            .all()
            .flatMap(to: View.self) { pods in
                let podsData = pods.isEmpty ? nil : pods
                let context = IndexContext(title: "Homepage", pods: podsData)
                return try req.view().render("index", context)
        }
    }
    
    func listHandler(_ req: Request) throws -> Future<View> {
        return Pod.query(on: req)
            .all()
            .flatMap(to: View.self) { pods in
                let podsData = pods.isEmpty ? nil : pods
                let context = ListContext(
                    title: "Listpage",
                    pods: podsData)
                return try req.view().render("list", context)
        }
    }
    
    func podHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Pod.self)
            .flatMap(to: View.self) { pod in
                let context = PodContext(
                    title: pod.name,
                    pod: pod)
                return try req.view().render("pod", context)
        }
    }

    func addPodHandler(_ req: Request) throws -> Future<View> {
        let context = AddPodContext(title: "Addpage")
        return try req.view().render("add", context)
    }
    
    func addPodPostHandler(_ req: Request, pod: Pod) throws -> Future<Response> {
        return pod.save(on: req).map(to: Response.self) {
            pod in
            guard let id = pod.id else {
                throw Abort(.internalServerError)
            }
            return req.redirect(to: "/pods/\(id)")
        }
    }
}

struct IndexContext: Encodable {
    let title: String
    let pods: [Pod]?
}

struct ListContext: Encodable {
    let title: String
    let pods: [Pod]?
}

struct PodContext: Encodable {
    let title: String
    let pod: Pod
}

struct AddPodContext: Encodable {
    let title: String
}
