import Vapor

private class RequestPerformer {

    let settings: SettingsStore

    let provider: CookpadProvider

    let eventLoop: EventLoop

    let page: Int

    let perPage: Int

    init(settings: SettingsStore, provider: CookpadProvider, eventLoop: EventLoop, page: Int, perPage: Int) {

        self.settings = settings
        self.provider = provider
        self.eventLoop = eventLoop
        self.page = page
        self.perPage = perPage
    }

    func getSuggestions() throws -> Future<SearchResults> {

        // Build the new url
        var components = URLComponents()
        components.scheme = "https"
        components.host = settings.apiHost
        components.path = "/v9/recipe_feeds"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]

        // Ensure the url is valid
        guard let url = components.url else { throw Abort(.internalServerError) }

        // Build the complete request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(settings.apiAnonymousToken)", forHTTPHeaderField: "Authorization")
        request.addValue(String(provider.rawValue), forHTTPHeaderField: "X-Cookpad-Provider-Id")

        // Return a description of the request for display
        return URLSession.shared
            .perform(request: request, in: eventLoop, expecting: GWResponse<[GWFeed]>.self)
            .map { [provider] in SearchResults(response: $0, provider: provider) }
    }

    func search(with query: String, order: String) throws -> Future<SearchResults> {

        // Build the new url
        var components = URLComponents()
        components.scheme = "https"
        components.host = settings.apiHost
        components.path = "/v9/recipes"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "order", value: order),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]

        // Ensure the url is valid
        guard let url = components.url else { throw Abort(.internalServerError) }

        // Build the complete request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(settings.apiAnonymousToken)", forHTTPHeaderField: "Authorization")
        request.addValue(String(provider.rawValue), forHTTPHeaderField: "X-Cookpad-Provider-Id")

        // Return a description of the request for display
        return URLSession.shared
            .perform(request: request, in: eventLoop, expecting: GWResponse<[GWRecipe]>.self)
            .map { [provider] in SearchResults(response: $0, provider: provider) }
    }
}

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
