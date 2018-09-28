import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
//    let usersController = UsersController()
//    try router.register(collection: usersController)
    
    let podsController = PodsController()
    try router.register(collection: podsController)
    
    let websiteController = WebsiteController()
    try router.register(collection: websiteController)
}
