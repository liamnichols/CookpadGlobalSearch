import Vapor

struct SearchQuery: Codable {

    enum Order: String, Codable {
        case recent, popularity
    }

    let query: String
    let language: String
    let order: Order
    let page: Int
    let per_page: Int

    func validate() throws {

        guard !query.isEmpty else { throw Abort(badRequest: .emptyQuery) }
        guard !language.isEmpty else { throw Abort(badRequest: .emptyLanguage) }
        guard page > 0 else { throw Abort(badRequest: .invalidPageNumber) }
        guard per_page > 0 else { throw Abort(badRequest: .invalidPerPage) }
        guard per_page <= 100 else { throw Abort(badRequest: .tooManyItems) }
    }

    func detectProvider() -> CookpadProvider? {

        return Language(language).provider
    }
}
