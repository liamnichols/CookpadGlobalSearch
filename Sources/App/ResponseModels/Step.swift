import Foundation

struct Step: Codable {

    let identifier: Int

    let instruction: String

    let imageUrls: [URL]
}

import Vapor

extension Step: Content {

    init(step: GWStep) {
        self.identifier = step.id
        self.instruction = step.description ?? ""
        self.imageUrls = step.attachments.compactMap { $0.image?.middleImageURL }
    }
}
