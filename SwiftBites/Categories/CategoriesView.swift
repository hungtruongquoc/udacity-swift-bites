import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var refreshTrigger: UUID = UUID()
    @State private var query = ""
    
    private var filteredCategories: [Category] {
        let predicate = #Predicate<Category> {
            $0.name.localizedStandardContains(query)
        }
        
        let descriptor = FetchDescriptor<Category>(
            predicate: query.isEmpty ? nil : predicate,
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
        
        do {
            let filteredCategories = try modelContext.fetch(descriptor)
            return filteredCategories
        } catch {
            return []
        }
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Categories")
                .searchable(text: $query, prompt: "Search categories")
                .toolbar {
                    if !filteredCategories.isEmpty {
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
    
    @ViewBuilder
    private var content: some View {
        if filteredCategories.isEmpty {
            if query.isEmpty {
                empty
            } else {
                noResults
            }
        } else {
            list
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
    
    private var list: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                ForEach(filteredCategories) { category in
                    CategorySection(category: category)
                        .id("\(category.id)-\(refreshTrigger)")
                }
            }
        }
        .searchable(text: $query, prompt: "Search categories")
    }
}

#Preview {
    CategoriesView()
        .modelContainer(for: Category.self, inMemory: true)
}
