import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    @Attribute(.unique) var name: String
    var summary: String
    @Relationship var category: Category?
    var serving: Int
    var time: Int
    @Relationship(deleteRule: .cascade) var ingredients: [RecipeIngredient] = []
    var instructions: String
    var imageData: Data?
    var id: UUID

    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        category: Category?,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredient],
        instructions: String,
        imageData: Data? = nil
    ) {
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
        self.id = id
    }
}

@Model
class RecipeIngredient: Identifiable {
    var ingredient: Ingredient
    var quantity: String

    init(ingredient: Ingredient, quantity: String) {
        self.ingredient = ingredient
        self.quantity = quantity
    }
}

@Model
class Ingredient: Identifiable {
    @Attribute(.unique) var name: String
    var recipes: [RecipeIngredient] = []
    var id: UUID

    init(id: UUID = UUID(), name: String) {
        self.name = name
        self.id = id
    }
}

@Model
class Category: Identifiable {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .nullify, inverse: \Recipe.category) var recipes: [Recipe] = []
    var id: UUID

    init(id: UUID = UUID(), name: String) {
        self.name = name
        self.id = id
    }
}
