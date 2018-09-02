import Vapor
import Fluent

struct PodsController: RouteCollection {
    func boot(router: Router) throws {
        let podsRoutes = router.grouped("api", "pods")
        podsRoutes.get(use: getAllHandler)
        podsRoutes.get(Pod.parameter, use: getHandler)
        podsRoutes.post(Pod.self, use: createHandler)
        podsRoutes.delete(Pod.parameter, use: deleteHandler)
        podsRoutes.put(Pod.parameter, use: updateHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Pod]> {
        return Pod.query(on: req).all()
    }
    
    func createHandler(_ req: Request, data: Pod) throws -> Future<Pod> {
        let pod = Pod(name: data.name, url: data.url)
        return pod.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Pod> {
        return try req.parameters.next(Pod.self)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Pod> {
        return try flatMap(
            to: Pod.self,
            req.parameters.next(Pod.self),
            req.content.decode(Pod.self)
        ) { pod, updatedPod in
            pod.name = updatedPod.name
            pod.url = updatedPod.url
            return pod.save(on: req)
        }
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Pod.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
}

