import Vapor

enum InternalServerError {

    case badEnvironment(key: String)

    var reason: String {
        switch self {
        case .badEnvironment(let key):
            return "The '\(key)' environment variable was not configured correctly."
        }
    }
}


extension Abort {

    init(internalServerError: InternalServerError) {
        self.init(.internalServerError, reason: internalServerError.reason)
    }
}
