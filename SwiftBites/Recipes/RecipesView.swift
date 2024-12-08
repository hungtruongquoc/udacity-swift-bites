import SwiftUI

struct RecipesView: View {
    @Environment(\.storage) private var storage
    @State private var queryResults: [Recipe] = [] // State to hold queried recipes
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\Recipe.name)

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
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
                    loadRecipes() // Load recipes when the view appears
                }
        }
    }

    // MARK: - Views

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
        } else {
            list(for: queryResults.filter {
                if query.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(query) || $0.summary.localizedStandardContains(query)
                }
            }.sorted(using: sortOrder))
        }
    }

    var empty: some View {
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
            if recipes.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes, id: \.id) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                }
            }
        }
        .searchable(text: $query)
        .onChange(of: query) { oldQuery, newQuery in
            filterRecipes(by: newQuery)
        }
    }

    // MARK: - Helper Methods

    private func loadRecipes() {
        queryResults = storage.fetchRecipes() // Load initial recipes into queryResults
    }

    private func filterRecipes(by query: String) {
        if query.isEmpty {
            queryResults = storage.fetchRecipes() // Reload all recipes if query is empty
        } else {
            queryResults = storage.fetchRecipes().filter {
                $0.name.localizedStandardContains(query) || $0.summary.localizedStandardContains(query)
            }
        }
    }
}
