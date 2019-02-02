import Foundation

struct SearchResults: Codable {

    let results: [Recipe]

    let language: Language

    let provider: Int

    let nextPage: Int?

    let previousPage: Int?

    let totalCount: Int
}

import Vapor

extension SearchResults: Content {

    init(response: GWResponse<[GWRecipe]>, provider: CookpadProvider) {
        self.results = response.result.map { Recipe(recipe: $0, language: provider.language) }
        self.language = provider.language
        self.provider = provider.id
        self.nextPage = response.extra.links?.next?.page
        self.previousPage = response.extra.links?.prev?.page
        self.totalCount = response.extra.total_count ?? 0
    }
}
