import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
    var container: ModelContainer = {
        let schema = Schema([
            Category.self,
            Ingredient.self,
            Recipe.self,
            RecipeIngredient.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create Model Container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.storage, Storage(context: container.mainContext))
                .modelContainer(container)
        }
    }
}
