import Vapor

struct SettingsStore: Service {

    /// Real global-web hostname
    let apiHost: String

    /// Real global-web anonymous token for guest user requests
    let apiAnonymousToken: String

    /// API access token for this apps interface
    let accessToken: String

    fileprivate init() throws {

        guard let apiHost = Environment.get("CKPD_API_HOST"), !apiHost.isEmpty else {
            throw Abort(internalServerError: .badEnvironment(key: "CKPD_API_HOST"))
        }
        
        guard let apiAnonymousToken = Environment.get("CKPD_API_ANONYMOUS_TOKEN"), !apiAnonymousToken.isEmpty else {
            throw Abort(internalServerError: .badEnvironment(key: "CKPD_API_ANONYMOUS_TOKEN"))
        }

        guard let accessToken = Environment.get("GS_ACCESS_TOKEN"), !accessToken.isEmpty else {
            throw Abort(internalServerError: .badEnvironment(key: "GS_ACCESS_TOKEN"))
        }

        self.apiHost = apiHost
        self.apiAnonymousToken = apiAnonymousToken
        self.accessToken = accessToken
    }

    func guardAuthentication(for request: Request) throws {

        // Ensure that a valid header had been supplied while making the request
        guard request.http.headers[.authorization].first(where: { $0 == "Bearer \(accessToken)"}) != nil else {
            throw Abort(.unauthorized)
        }
    }
}

extension Container {

    func settingsStore() throws -> SettingsStore {
        return try make(SettingsStore.self)
    }
}

struct SettingsProvider: Provider {

    func register(_ services: inout Services) throws {

        services.register(SettingsStore.self) { container -> SettingsStore in

            return try SettingsStore()
        }
    }

    func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {

        return container.eventLoop.newSucceededFuture(result: ())
    }
}
