import Foundation

struct GWUser: Decodable {

    let id: Int

    let name: String?

    let profile_message: String?

    let location: String?

    let image: GWImage?

    let background_image: GWImage?

    let recipe_count: Int?

    let follower_count: Int?

    let followee_count: Int?

    let photo_comment_count: Int?

    let href: URL

    let staff: Bool

    let draft_recipes_count: Int?
}
