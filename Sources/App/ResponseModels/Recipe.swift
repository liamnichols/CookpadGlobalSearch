import Foundation

struct Recipe: Codable {

    let identifier: Int

    let language: Language

    let title: String

    let story: String

    let servings: String

    let cookingTime: String

    let publishedAt: Date?

    let url: URL

    let viewCount: Int

    let likeCount: Int

    let bookmarkCount: Int

    let commentCount: Int

    let cooksnapCount: Int

    let imageUrl: URL?

    let author: User

    let ingredients: [Ingredient]

    let steps: [Step]
}

import Vapor

extension Recipe: Content {

    init(recipe: GWRecipe, language: Language) {
        self.identifier = recipe.id
        self.language = language
        self.title = recipe.title ?? ""
        self.story = recipe.story ?? ""
        self.servings = recipe.serving ?? ""
        self.cookingTime = recipe.cooking_time ?? ""
        self.publishedAt = recipe.published_at
        self.url = recipe.href
        self.viewCount = recipe.view_count ?? 0
        self.likeCount = recipe.likes_count ?? 0
        self.bookmarkCount = recipe.bookmarks_count ?? 0
        self.commentCount = recipe.comments_count ?? 0
        self.cooksnapCount = recipe.photo_comments_count ?? 0
        self.imageUrl = recipe.image?.middleImageURL
        self.author = User(user: recipe.user)
        self.ingredients = recipe.ingredients.map { Ingredient(ingredient: $0) }
        self.steps = recipe.steps.map { Step(step: $0) }
    }
}
