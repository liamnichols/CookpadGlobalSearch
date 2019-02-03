import Vapor

enum BadRequest {
    case emptyQuery
    case emptyLanguage
    case unknownProvider

    var reason: String {
        switch self {
        case .emptyQuery:
            return "'query' parameter must supply a non-empty string."
        case .emptyLanguage:
            return "'language' parameter must supply a non-empty string."
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
