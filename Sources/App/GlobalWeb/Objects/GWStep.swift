import Foundation

struct GWStep: Decodable {

    let id: Int

    let description: String?

    let attachments: [GWStepAttachment]
}
