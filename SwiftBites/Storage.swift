import Foundation
import SwiftUI
import SwiftData

/**
 * This file acts as a mock database for temporary data storage, providing CRUD functionality.
 * It is essential to remove this file before the final project submission.
 */

@Observable
final class Storage {
    private let modelContext: ModelContext?
    
  enum Error: LocalizedError {
    case ingredientExists
    case categoryExists
    case recipeExists
    case missingContext

    var errorDescription: String? {
      switch self {
          case .ingredientExists:
            return "Ingredient with the same name exists"
          case .categoryExists:
            return "Category with the same name exists"
          case .recipeExists:
            return "Recipe with the same name exists"
        case .missingContext:
          return "Missing ModelContext"
      }
    }
  }

    init(context: ModelContext?) {
        modelContext = context
    }
    
    private func requireContext() throws -> ModelContext {
        guard let context = modelContext else {
            throw Error.missingContext
        }
        return context
    }

    // Fetch Ingredients
    func fetchIngredients() -> [Ingredient] {
        let context = try! requireContext()
        let fetchDescriptor = FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }

    // Fetch Categories
    func fetchCategories() -> [Category] {
        let context = try! requireContext()
        let fetchDescriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }

    // Fetch Recipes
    func fetchRecipes() -> [Recipe] {
        let context = try! requireContext()
        let fetchDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }

  // MARK: - Categories

    func addCategory(name: String) throws {
        let context = try! requireContext()
        // Check if the category already exists
        guard fetchCategories().contains(where: { $0.name == name }) == false else {
            throw Error.categoryExists
        }

        // Create and insert the new category
        let newCategory = Category(name: name)
        context.insert(newCategory)
    }

    // Delete an existing category
    func deleteCategory(id: UUID) {
        let context = try! requireContext()
        guard let category = fetchCategories().first(where: { $0.id == id}) else { return }
        context.delete(category)

        // Remove category references from recipes
        let recipesWithCategory = fetchRecipes().filter { $0.category?.id == id }
        for recipe in recipesWithCategory {
            recipe.category = nil
            try? context.save()
        }
    }

    // Update an existing category
    func updateCategory(id: UUID, name: String) throws {
        let context = try! requireContext()
        guard fetchCategories().contains(where: { $0.name == name && $0.id != id }) == false else {
            throw Error.categoryExists
        }
        guard let category = fetchCategories().first(where: { $0.id == id }) else { return }
        category.name = name
    }

  // MARK: - Ingredients

    func addIngredient(name: String) throws {
        let context = try! requireContext()
      guard fetchIngredients().contains(where: { $0.name == name }) == false else {
          throw Error.ingredientExists
      }
        context.insert(Ingredient(name: name))
    }

    func deleteIngredient(id: UUID) {
        let context = try! requireContext()
        // Find the ingredient by ID
        guard let ingredient = fetchIngredients().first(where: { $0.id == id }) else {
            return // Exit if no matching ingredient is found
        }

        // Delete the ingredient from the model context
        context.delete(ingredient)
    }

    func updateIngredient(id: UUID, name: String) throws {
        let context = try! requireContext()
        // Check if an ingredient with the same name already exists (but with a different ID)
        guard fetchIngredients().contains(where: { $0.name == name && $0.id != id }) == false else {
            throw Error.ingredientExists
        }

        // Find the ingredient by ID
        guard let ingredient = fetchIngredients().first(where: { $0.id == id }) else {
            return // Exit if no matching ingredient is found
        }

        // Update the ingredient's name
        ingredient.name = name
        try? context.save()
    }

  // MARK: - Recipes

    func addRecipe(
        name: String,
        summary: String,
        category: Category?,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredient],
        instructions: String,
        imageData: Data?
    ) throws {
        let context = try! requireContext()
        // Check if a recipe with the same name already exists
        guard fetchRecipes().contains(where: { $0.name == name }) == false else {
            throw Error.recipeExists
        }
        
        let newRecipe = Recipe(
            name: name,
            summary: summary,
            category: nil,
            serving: serving,
            time: time,
            ingredients: [],
            instructions: instructions,
            imageData: imageData
        )

        // Assign category and ingredients after creation
        newRecipe.category = category
        newRecipe.ingredients = ingredients
        context.insert(newRecipe)
        
        // Associate the recipe with the category, if provided
        if let category = category {
            category.recipes.append(newRecipe)
            try? context.save()
        }
    }

    func deleteRecipe(id: UUID) {
        let context = try! requireContext()
        // Find the recipe by its ID
        guard let recipe = fetchRecipes().first(where: { $0.id == id }) else {
            return // Exit if no matching recipe is found
        }

        // Remove the recipe from its associated category
        if let category = recipe.category {
            category.recipes.removeAll(where: { $0.id == id })
        }

        // Delete the recipe from the model context
        context.delete(recipe)
    }

    func updateRecipe(
        id: UUID,
        name: String,
        summary: String,
        category: Category?,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredient],
        instructions: String,
        imageData: Data?
    ) throws {
        let context = try! requireContext()
        guard fetchRecipes().contains(where: { $0.name == name && $0.id != id }) == false else {
            throw Error.recipeExists
        }

        guard let recipe = fetchRecipes().first(where: { $0.id == id }) else {
            return
        }

        // Remove recipe from old category if it exists
        if let oldCategory = recipe.category {
            oldCategory.recipes.removeAll(where: { $0.id == recipe.id })
        }

        // Update recipe properties
        recipe.name = name
        recipe.summary = summary
        recipe.serving = serving
        recipe.time = time
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.imageData = imageData
        
        // Handle category change
        recipe.category = category
        if let newCategory = category {
            // Only append if not already in the category's recipes
            if !newCategory.recipes.contains(where: { $0.id == recipe.id }) {
                newCategory.recipes.append(recipe)
            }
        }
        
        try? context.save()  // Save after updating relationships
    }
    
    func updateRecipeCategory(recipeId: UUID, newCategory: Category?) {
        let context = try! requireContext()
        guard let recipe = fetchRecipes().first(where: { $0.id == recipeId }) else {
            return
        }
        
        // Remove from old category
        if let oldCategory = recipe.category {
            oldCategory.recipes.removeAll(where: { $0.id == recipe.id })
        }
        
        // Add to new category
        recipe.category = newCategory
        if let newCategory = newCategory {
            newCategory.recipes.append(recipe)
        }
        
        try? context.save()
    }
    
    func addRecipeIngredient(selectedIngredient: Ingredient, quantity: String) -> RecipeIngredient? {
        let context = try! requireContext()
        
        guard let foundIngredient = fetchIngredients().first(where: { $0.id == selectedIngredient.id }) else {
            return nil
        }

        let newRecipeIngredient = RecipeIngredient(ingredient: foundIngredient, quantity: quantity)
        context.insert(newRecipeIngredient)
        try? context.save()

        return newRecipeIngredient
    }
}

struct StorageKey: EnvironmentKey {
    static var defaultValue: Storage = Storage(context: nil)
}

extension EnvironmentValues {
    var storage: Storage {
        get { self[StorageKey.self] }
        set { self[StorageKey.self] = newValue }
    }
}
