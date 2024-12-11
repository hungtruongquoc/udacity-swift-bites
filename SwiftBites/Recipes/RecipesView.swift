import SwiftUI

struct RecipesView: View {
    @Environment(\.storage) private var storage
    @State private var queryResults: [Recipe] = []
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\Recipe.name)
    
    private var filteredRecipes: [Recipe] {
        let predicate = #Predicate<Recipe> {
            $0.name.localizedStandardContains(query) ||
            $0.summary.localizedStandardContains(query)
        }
        
        if query.isEmpty {
            return queryResults.sorted(using: sortOrder)
        } else {
            return queryResults.filter { recipe in
                (try? predicate.evaluate(recipe)) ?? false
            }.sorted(using: sortOrder)
        }
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
                .searchable(text: $query, prompt: "Search recipes")
                .toolbar {
                    if !queryResults.isEmpty {
                        sortOptions
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(value: RecipeForm.Mode.add) {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode)
                }
                .onAppear {
                    loadRecipes()
                }
        }
    }
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name")
                        .tag(SortDescriptor(\Recipe.name))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor(\Recipe.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor(\Recipe.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor(\Recipe.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor(\Recipe.time, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if queryResults.isEmpty {
            empty
        } else if filteredRecipes.isEmpty && !query.isEmpty {
            noResults
        } else {
            list(for: filteredRecipes)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Recipes", systemImage: "list.clipboard")
            },
            description: {
                Text("Recipes you add will appear here.")
            },
            actions: {
                NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
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
    
    private func list(for recipes: [Recipe]) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCell(recipe: recipe)
                }
            }
        }
    }
    
    private func loadRecipes() {
        queryResults = storage.fetchRecipes()
    }
}
