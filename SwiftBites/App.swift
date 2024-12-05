import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
            .modelContainer(for: [Recipe.self, Ingredient.self, RecipeIngredient.self, Category.self])
    }
  }
}
