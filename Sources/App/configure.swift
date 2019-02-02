import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    // Register any additional providers
    try services.register(SettingsProvider())

    // Pretty print output when running during dev on a mac
    if #available(OSX 10.13, *) {
        var content = ContentConfig.default()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        content.use(encoder: encoder, for: .json)
        services.register(content)
    }

}
