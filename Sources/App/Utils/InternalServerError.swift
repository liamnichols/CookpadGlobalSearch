import Vapor

enum InternalServerError {

    case badEnvironment(key: String)
    case badURLComponents(path: String)

    var reason: String {
        switch self {
        case .badEnvironment(let key):
            return "The '\(key)' environment variable was not configured correctly."
        case .badURLComponents(let path):
            return "The url components were not able to construct a valid URL for '\(path)'."
        }
    }
}


extension Abort {

    init(internalServerError: InternalServerError) {
        self.init(.internalServerError, reason: internalServerError.reason)
    }
}
