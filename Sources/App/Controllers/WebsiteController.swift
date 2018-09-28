import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("pods", Pod.parameter, use: podHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        return Pod.query(on: req)
            .all()
            .flatMap(to: View.self) { pods in
                let acronymsData = pods.isEmpty ? nil : pods
                let context = IndexContext(
                    title: "Homepage",
                    pods: acronymsData)
                return try req.view().render("index", context)
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
}

struct IndexContext: Encodable {
    let title: String
    let pods: [Pod]?
}

struct PodContext: Encodable {
    let title: String
    let pod: Pod
}
