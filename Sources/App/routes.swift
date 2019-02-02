import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Performs a search via the Cookpad Global API using an automatically inferred provider.
    router.get("recipes") { req -> Future<SearchResults> in

        // Read the base settings as we need these for forwarding requests
        let settings = try req.settingsStore()

        // Read the search query and ensure it's valid
        let searchQuery = try req.query.decode(SearchQuery.self)
        try searchQuery.validate()

        // Infer the provider based on the search query
        guard let provider = searchQuery.detectProvider() else {
            throw Abort(badRequest: .unknownProvider)
        }

        // Build the new url
        var components = URLComponents()
        components.scheme = "https"
        components.host = settings.apiHost
        components.path = "/v8/recipes"
        components.queryItems = [
            URLQueryItem(name: "query", value: searchQuery.query),
            URLQueryItem(name: "order", value: searchQuery.order.rawValue),
            URLQueryItem(name: "page", value: String(searchQuery.page)),
            URLQueryItem(name: "per_page", value: String(searchQuery.per_page))
        ]

        // Ensure the url is valid
        guard let url = components.url else { throw Abort.init(.internalServerError) }

        // Build the complete request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(settings.apiAnonymousToken)", forHTTPHeaderField: "Authorization")
        request.addValue(String(provider.rawValue), forHTTPHeaderField: "X-Cookpad-Provider-Id")

        // Return a description of the request for display
        return URLSession.shared
            .perform(request: request, in: req.eventLoop, expecting: GWResponse<[GWRecipe]>.self)
            .map { SearchResults(response: $0, provider: provider) }
    }
}
