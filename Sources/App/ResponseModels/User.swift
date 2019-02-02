import Foundation

struct User: Codable {

    let identifier: Int

    let name: String

    let biography: String

    let location: String

    let imageUrl: URL?

    let url: URL

    let isStaff: Bool

    let publishedRecipeCount: Int

    let privateRecipeCount: Int

    let followerCount: Int

    let followingCount: Int

    let sentCooksnapsCount: Int
}

import Vapor

extension User: Content {

    init(user: GWUser) {
        self.identifier = user.id
        self.name = user.name ?? ""
        self.biography = user.profile_message ?? ""
        self.location = user.location ?? ""
        self.imageUrl = user.image?.middleImageURL
        self.url = user.href
        self.isStaff = user.staff
        self.publishedRecipeCount = user.recipe_count ?? 0
        self.privateRecipeCount = user.draft_recipes_count ?? 0
        self.followerCount = user.follower_count ?? 0
        self.followingCount = user.followee_count ?? 0
        self.sentCooksnapsCount = user.photo_comment_count ?? 0
    }
}
