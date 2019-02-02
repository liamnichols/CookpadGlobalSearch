import Vapor

class RequestPerformer {

    let session: URLSession = .shared

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

        // Create the request for
        let request = try makeRequest(forPath: "recipe_feeds")
        return session
            .perform(request: request, in: eventLoop, expecting: GWResponse<[GWFeed]>.self)
            .map { [provider] in SearchResults(response: $0, provider: provider) }
    }

    func search(with query: String, order: String) throws -> Future<SearchResults> {

        let request = try makeRequest(forPath: "recipes", queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "order", value: order)
        ])

        return session
            .perform(request: request, in: eventLoop, expecting: GWResponse<[GWRecipe]>.self)
            .map { [provider] in SearchResults(response: $0, provider: provider) }
    }

    private func makeRequest(forPath path: String, queryItems: [URLQueryItem] = []) throws -> URLRequest {

        // Make the url and pass it into a request object
        let url = try makeURL(forPath: path, queryItems: queryItems)
        var request = URLRequest(url: url)

        // Append the default headers for api queries
        request.addValue("Bearer \(settings.apiAnonymousToken)", forHTTPHeaderField: "Authorization")
        request.addValue(String(provider.rawValue), forHTTPHeaderField: "X-Cookpad-Provider-Id")

        return request
    }

    private func makeURL(forPath path: String, queryItems: [URLQueryItem] = []) throws -> URL {

        // Make the new url
        var components = URLComponents()
        components.scheme = "https"
        components.host = settings.apiHost
        components.path = "/v9/" + path
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ] + queryItems

        // Throw if the url was invalid, otherwise return it
        guard let url = components.url else { throw Abort(internalServerError: .badURLComponents(path: path)) }
        return url
    }
}
