import Vapor

struct SettingsStore: Service {

    let apiHost: String

    let apiAnonymousToken: String

    fileprivate init() throws {

        guard let apiHost = Environment.get("CKPD_API_HOST"), !apiHost.isEmpty else {
            throw Abort(internalServerError: .badEnvironment(key: "CKPD_API_HOST"))
        }
        
        guard let apiAnonymousToken = Environment.get("CKPD_API_ANONYMOUS_TOKEN"), !apiAnonymousToken.isEmpty else {
            throw Abort(internalServerError: .badEnvironment(key: "CKPD_API_ANONYMOUS_TOKEN"))
        }

        self.apiHost = apiHost
        self.apiAnonymousToken = apiAnonymousToken
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
