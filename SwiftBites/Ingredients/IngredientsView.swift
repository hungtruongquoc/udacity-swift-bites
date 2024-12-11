import SwiftUI

struct IngredientsView: View {
    typealias Selection = (Ingredient) -> Void
    
    let selection: Selection?
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
    @Environment(\.storage) private var storage
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var ingredients: [Ingredient] = []
    
    private var filteredIngredients: [Ingredient] {
        let predicate = #Predicate<Ingredient> {
            $0.name.localizedStandardContains(query)
        }
        
        if query.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { ingredient in
                (try? predicate.evaluate(ingredient)) ?? false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Ingredients")
                .searchable(text: $query, prompt: "Search ingredients")
                .toolbar {
                    if !ingredients.isEmpty {
                        NavigationLink(value: IngredientForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: IngredientForm.Mode.self) { mode in
                    IngredientForm(mode: mode)
                }
                .onAppear {
                    ingredients = storage.fetchIngredients()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if ingredients.isEmpty {
            empty
        } else if filteredIngredients.isEmpty && !query.isEmpty {
            noResults
        } else {
            list(for: filteredIngredients)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
    }
    
    private func list(for ingredients: [Ingredient]) -> some View {
        List {
            ForEach(ingredients) { ingredient in
                row(for: ingredient)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            delete(ingredient: ingredient)
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient) -> some View {
        if let selection {
            Button(
                action: {
                    selection(ingredient)
                    dismiss()
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
        }
    }
    
    private func title(for ingredient: Ingredient) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    private func delete(ingredient: Ingredient) {
        storage.deleteIngredient(id: ingredient.id)
    }
}
