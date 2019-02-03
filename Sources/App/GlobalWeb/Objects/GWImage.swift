import Foundation

struct GWImage: Decodable {

    let id: String

    let url: URL
}

extension GWImage {

    var middleImageURL: URL {
        return url
            .appendingPathComponent("m")
            .appendingPathComponent("photo")
            .appendingPathExtension("jpg")
    }
}
