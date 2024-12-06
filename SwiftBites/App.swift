import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
    // Set up the model container for your app
    @State private var modelContainer =  {
        let schema = Schema([Recipe.self, Ingredient.self, RecipeIngredient.self, Category.self])
        let container: ModelContainer = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.storage, Storage(context: modelContainer.mainContext))
        }
    }
}
