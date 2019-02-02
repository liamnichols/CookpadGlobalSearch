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
        self.init(recipes: response.result, extra: response.extra, provider: provider)
    }

    init(response: GWResponse<[GWFeed]>, provider: CookpadProvider) {
        self.init(recipes: response.result.compactMap({ $0.recipe }), extra: response.extra, provider: provider)
    }

    private init(recipes: [GWRecipe], extra: GWExtra, provider: CookpadProvider) {
        self.results = recipes.map({ Recipe(recipe: $0, language: provider.language) })
        self.language = provider.language
        self.provider = provider.id
        self.nextPage = extra.links?.next?.page
        self.previousPage = extra.links?.prev?.page
        self.totalCount = extra.total_count ?? 0
    }
}
