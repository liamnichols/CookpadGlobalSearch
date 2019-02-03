import Foundation

enum CookpadProvider: Int, CaseIterable {

    /// The default provider
    static let `default`: CookpadProvider = .us

    case us = 1
    case spain = 2
    case indonesia = 3
    case thailand = 4
    case vietnam = 5
    case france = 6
    case philippine = 7
    case japan = 8
    case mena = 9
    case brazil = 10
    case taiwan = 12
    case italy = 14
    case iran = 15
    case hungary = 16
    case denmark = 17
    case poland = 18
    case greece = 21
    case russia = 23
    case india = 24

    init?(id: Int) {
        self.init(rawValue: id)
    }

    /// The provider ID used to identify with the API.
    /// Should match the values in [global-web/config/providers.yml](https://github.com/cookpad/global-web/blob/master/config/providers.yml)
    var id: Int {
        return rawValue
    }

    /// The name of the provider as per the web-api.
    /// Should match the values in [global-web/config/providers.yml]
    /// (https://github.com/cookpad/global-web/blob/master/config/provider_configurations.yml)
    var name: String {
        switch self {
        case .us:
            return "cookpad-us"
        case .spain:
            return "cookpad-spain"
        case .indonesia:
            return "cookpad-indonesia"
        case .thailand:
            return "cookpad-thailand"
        case .vietnam:
            return "cookpad-vietnam"
        case .france:
            return "cookpad-france"
        case .philippine:
            return "cookpad-philippine"
        case .japan:
            return "cookpad-japan"
        case .mena:
            return "cookpad-mena"
        case .brazil:
            return "cookpad-brasil"
        case .taiwan:
            return "cookpad-taiwan"
        case .hungary:
            return "cookpad-hungary"
        case .iran:
            return "cookpad-iran"
        case .italy:
            return "cookpad-italy"
        case .greece:
            return "cookpad-greece"
        case .denmark:
            return "cookpad-denmark"
        case .russia:
            return "cookpad-russia"
        case .poland:
            return "cookpad-poland"
        case .india:
            return "cookpad-india (Hindi)"
        }
    }

    var language: Language {
        switch self {
        case .us:
            return Language("en")
        case .spain:
            return Language("es")
        case .indonesia:
            return Language("id")
        case .thailand:
            return Language("th")
        case .vietnam:
            return Language("vi")
        case .france:
            return Language("fr")
        case .philippine:
            return Language("fil")
        case .japan:
            return Language("jp")
        case .mena:
            return Language("ar")
        case .brazil:
            return Language("pt")
        case .hungary:
            return Language("hu")
        case .iran:
            return Language("fa")
        case .taiwan:
            return Language("zh")
        case .italy:
            return Language("it")
        case .greece:
            return Language("el")
        case .denmark:
            return Language("da")
        case .russia:
            return Language("ru")
        case .poland:
            return Language("pl")
        case .india:
            return Language("hi")
        }
    }
}
