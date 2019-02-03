import Vapor

struct RecipesQuery: Codable {

    enum Order: String, Codable {
        case recent, popularity
    }

    enum Mode {
        case suggestions
        case search(query: String, order: Order)
    }

    let language: String

    let query: String?
    let order: Order?
    let page: Int?
    let perPage: Int?

    var mode: Mode {
        if let query = query {
            return .search(query: query, order: order ?? .recent)
        } else {
            return .suggestions
        }
    }

    func validate() throws {

        // Must always supply a non-empty language
        guard !language.isEmpty else { throw Abort(badRequest: .emptyLanguage) }

        // Mode speicifc queries
        switch mode {
        case .suggestions:
            break
        case .search(let query, _):
            guard !query.isEmpty else { throw Abort(badRequest: .emptyQuery) }
        }
    }
}
