import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Performs a search via the Cookpad Global API using an automatically inferred provider.
    router.get("recipes") { req -> Future<SearchResults> in

        // Read the base settings as we need these for forwarding requests
        let settings = try req.settingsStore()

        // Read the request query and ensure it's valid
        let requestQuery = try req.query.decode(RecipesQuery.self)
        try requestQuery.validate()

        // Infer the provider based on the query language
        guard let provider = Language(requestQuery.language).provider else {
            throw Abort(badRequest: .unknownProvider)
        }

        // Create a performer with our base settings
        let performer = RequestPerformer(settings: settings,
                                         provider: provider,
                                         eventLoop: req.eventLoop,
                                         page: requestQuery.page ?? 1,
                                         perPage: min(requestQuery.perPage ?? 20, 100))

        // Switch on the query mode and perform the correct action
        switch requestQuery.mode {
        case .suggestions:
            return try performer.getSuggestions()
        case let .search(query, order):
            return try performer.search(with: query, order: order.rawValue)
        }
    }
}
