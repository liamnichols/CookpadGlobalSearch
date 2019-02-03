import Foundation

struct Ingredient: Codable {

    let identifier: Int

    let value: String

    let parsedQuantity: String

    let parsedName: String

    let isHeadline: Bool
}

import Vapor

extension Ingredient: Content {

    init(ingredient: GWIngredient) {
        self.identifier = ingredient.id
        self.value = ingredient.quantity_and_name ?? ""
        self.parsedQuantity = ingredient.quantity?.trimmingCharacters(in: .whitespaces) ?? ""
        self.parsedName = ingredient.name?.trimmingCharacters(in: .whitespaces) ?? ""
        self.isHeadline = ingredient.headline
    }
}
