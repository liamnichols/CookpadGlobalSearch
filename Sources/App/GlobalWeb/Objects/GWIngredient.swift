import Foundation

struct GWIngredient: Decodable {

    let id: Int

    let name: String?

    let quantity: String?

    let quantity_and_name: String?

    let headline: Bool
}
