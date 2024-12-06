import SwiftUI

struct CategoriesView: View {
    @Environment(\.storage) private var storage
    @State private var queryResults: [Category] = [] // State to hold queried categories
    @State private var query = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Categories")
                .toolbar {
                    if !queryResults.isEmpty {
                        NavigationLink(value: CategoryForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: CategoryForm.Mode.self) { mode in
                    CategoryForm(mode: mode)
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode)
                }
                .onAppear {
                    loadCategories() // Load categories when the view appears
                }
        }
    }

    // MARK: - Views

    @ViewBuilder
    private var content: some View {
        if queryResults.isEmpty {
            empty
        } else {
            list(for: queryResults.filter {
                if query.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(query)
                }
            })
        }
    }

    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Categories", systemImage: "list.clipboard")
            },
            description: {
                Text("Categories you add will appear here.")
            },
            actions: {
                NavigationLink("Add Category", value: CategoryForm.Mode.add)
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

    private func list(for categories: [Category]) -> some View {
        return ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
                }
            }
        }
        .searchable(text: $query, prompt: "Search categories")
        .onChange(of: query) { oldQuery, newQuery in
            filterCategories(by: newQuery)
        }
    }

    // MARK: - Helper Methods

    private func loadCategories() {
        queryResults = storage.fetchCategories() // Load initial categories into queryResults
    }

    private func filterCategories(by query: String) {
        if query.isEmpty {
            queryResults = storage.fetchCategories() // Reload all categories if query is empty
        } else {
            queryResults = storage.fetchCategories().filter { $0.name.localizedStandardContains(query) }
        }
    }
}
