import SwiftUI
import SwiftData


struct CategoriesView: View {
    @Environment(\.storage) private var storage
    @Query(sort: \Category.name, order: .forward) private var queryResults: [Category]
    @State private var refreshTrigger: UUID = UUID()
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
            .id(refreshTrigger)
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
                    ForEach(categories) { category in
                        CategorySection(category: category)
                            .id("\(category.id)-\(refreshTrigger)")  // Add this line
                    }
                }
            }
        }
        .searchable(text: $query, prompt: "Search categories")
    }
}
