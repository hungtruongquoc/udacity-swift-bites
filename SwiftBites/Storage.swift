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
    
  // MARK: - Load

    func load() {
//        let context = try! requireContext()
//        // Clear existing data to avoid duplication
//        for ingredient in fetchIngredients() {
//            context.delete(ingredient)
//        }
//        for category in fetchCategories() {
//            context.delete(category)
//        }
//        for recipe in fetchRecipes() {
//            context.delete(recipe)
//        }
//
//        // Add Ingredients
//        let pizzaDough = Ingredient(name: "Pizza Dough")
//        let tomatoSauce = Ingredient(name: "Tomato Sauce")
//        let mozzarellaCheese = Ingredient(name: "Mozzarella Cheese")
//        let freshBasilLeaves = Ingredient(name: "Fresh Basil Leaves")
//        let extraVirginOliveOil = Ingredient(name: "Extra Virgin Olive Oil")
//        let salt = Ingredient(name: "Salt")
//        let chickpeas = Ingredient(name: "Chickpeas")
//        let tahini = Ingredient(name: "Tahini")
//        let lemonJuice = Ingredient(name: "Lemon Juice")
//        let garlic = Ingredient(name: "Garlic")
//        let cumin = Ingredient(name: "Cumin")
//        let water = Ingredient(name: "Water")
//        let paprika = Ingredient(name: "Paprika")
//        let parsley = Ingredient(name: "Parsley")
//        let spaghetti = Ingredient(name: "Spaghetti")
//        let eggs = Ingredient(name: "Eggs")
//        let parmesanCheese = Ingredient(name: "Parmesan Cheese")
//        let pancetta = Ingredient(name: "Pancetta")
//        let blackPepper = Ingredient(name: "Black Pepper")
//        let driedChickpeas = Ingredient(name: "Dried Chickpeas")
//        let onions = Ingredient(name: "Onions")
//        let cilantro = Ingredient(name: "Cilantro")
//        let coriander = Ingredient(name: "Coriander")
//        let bakingPowder = Ingredient(name: "Baking Powder")
//        let chickenThighs = Ingredient(name: "Chicken Thighs")
//        let yogurt = Ingredient(name: "Yogurt")
//        let cardamom = Ingredient(name: "Cardamom")
//        let cinnamon = Ingredient(name: "Cinnamon")
//        let turmeric = Ingredient(name: "Turmeric")
//
//        // Add Categories
//        let italian = Category(name: "Italian")
//        let middleEastern = Category(name: "Middle Eastern")
//
//        // Add Recipes
//        let margherita = Recipe(
//            name: "Classic Margherita Pizza",
//            summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
//            category: italian,
//            serving: 4,
//            time: 50,
//            ingredients: [
//                RecipeIngredient(ingredient: pizzaDough, quantity: "1 ball"),
//                RecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup"),
//                RecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded"),
//                RecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful"),
//                RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
//                RecipeIngredient(ingredient: salt, quantity: "Pinch")
//            ],
//            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
//            imageData: UIImage(named: "margherita")?.pngData()
//        )
//
//        let spaghettiCarbonara = Recipe(
//            name: "Spaghetti Carbonara",
//            summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
//            category: italian,
//            serving: 4,
//            time: 30,
//            ingredients: [
//                RecipeIngredient(ingredient: spaghetti, quantity: "400g"),
//                RecipeIngredient(ingredient: eggs, quantity: "4"),
//                RecipeIngredient(ingredient: parmesanCheese, quantity: "1 cup, grated"),
//                RecipeIngredient(ingredient: pancetta, quantity: "200g, diced"),
//                RecipeIngredient(ingredient: blackPepper, quantity: "To taste")
//            ],
//            instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
//            imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
//        )
//
//        let hummus = Recipe(
//            name: "Classic Hummus",
//            summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
//            category: middleEastern,
//            serving: 6,
//            time: 10,
//            ingredients: [
//                RecipeIngredient(ingredient: chickpeas, quantity: "1 can (15 oz)"),
//                RecipeIngredient(ingredient: tahini, quantity: "1/4 cup"),
//                RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
//                RecipeIngredient(ingredient: garlic, quantity: "1 clove, minced"),
//                RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
//                RecipeIngredient(ingredient: cumin, quantity: "1/2 teaspoon"),
//                RecipeIngredient(ingredient: salt, quantity: "To taste"),
//                RecipeIngredient(ingredient: water, quantity: "2-3 tablespoons"),
//                RecipeIngredient(ingredient: paprika, quantity: "For garnish"),
//                RecipeIngredient(ingredient: parsley, quantity: "For garnish")
//            ],
//            instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
//            imageData: UIImage(named: "hummus")?.pngData()
//        )
//
//        // Insert Ingredients, Categories, and Recipes into Context
//        let allItems: [any PersistentModel] = [pizzaDough, tomatoSauce, mozzarellaCheese, freshBasilLeaves, extraVirginOliveOil, salt, chickpeas, tahini, lemonJuice, garlic, cumin, water, paprika, parsley, spaghetti, eggs, parmesanCheese, pancetta, blackPepper, driedChickpeas, onions, cilantro, coriander, bakingPowder, chickenThighs, yogurt, cardamom, cinnamon, turmeric, italian, middleEastern, margherita, spaghettiCarbonara, hummus]
//
//        allItems.forEach { context.insert($0) }
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
        
        // Create the new Recipe object
        let newRecipe = Recipe(
            name: name,
            summary: summary,
            category: category,
            serving: serving,
            time: time,
            ingredients: ingredients,
            instructions: instructions,
            imageData: imageData
        )
        
        // Insert the new recipe into the model context
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
