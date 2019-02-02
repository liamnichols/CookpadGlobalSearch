import Foundation

struct Language: Codable {

    /// iso language code
    let code: String

    init(_ code: String) {
        self.code = code
    }

    /// Roughly matches to an available relevant provider
    var provider: CookpadProvider? {

        // TODO: Implement properly

        // Just check the providers base language. This wont work proerly in the long run but good for now
        return CookpadProvider.allCases.first(where: { $0.language.code == code })
    }
}

// MARK: - RawRepresentable
extension Language: RawRepresentable {

    typealias RawValue = String

    var rawValue: String {
        return code
    }

    init?(rawValue: String) {
        self.init(rawValue)
    }
}
