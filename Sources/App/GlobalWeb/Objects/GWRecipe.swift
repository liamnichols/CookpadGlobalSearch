import Foundation

struct GWRecipe: Decodable {

    let id: Int

    let title: String?

    let story: String?

    let serving: String?

    let cooking_time: String?

    let created_at: Date?

    let updated_at: Date?

    let published_at: Date?

    let href: URL

    let likes_count: Int?

    let photo_comments_count: Int?

    let edited_at: Date?

    let bookmarks_count: Int?

    let view_count: Int?

    let comments_count: Int?

    let comments_enabled: Bool

//    let comments_preview

    let steps: [GWStep]

    let ingredients: [GWIngredient]

    let user: GWUser

    let image: GWImage?

//    let original_copy
}
