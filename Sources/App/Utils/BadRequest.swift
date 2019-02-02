import Vapor

enum BadRequest {
    case emptyQuery
    case emptyLanguage
    case invalidPageNumber
    case invalidPerPage
    case tooManyItems
    case unknownProvider

    var reason: String {
        switch self {
        case .emptyQuery:
            return "'query' parameter must supply a non-empty string."
        case .emptyLanguage:
            return "'language' parameter must supply a non-empty string."
        case .invalidPageNumber:
            return "'page' must be greater than zero."
        case .invalidPerPage:
            return "'per_page' must be greater than zero."
        case .tooManyItems:
            return "'per_page' must be no more than 100."
        case .unknownProvider:
            return "Unable to infer the correct provider for this request."
        }
    }
}

extension Abort {

    init(badRequest: BadRequest) {
        self.init(.badRequest, reason: badRequest.reason)
    }
}
