import Foundation
import SwiftUI
import SwiftData

/**
 * This file acts as a mock database for temporary data storage, providing CRUD functionality.
 * It is essential to remove this file before the final project submission.
 */

@Observable
final class Storage {
    private let modelContext: ModelContext
    
  enum Error: LocalizedError {
    case ingredientExists
    case categoryExists
    case recipeExists

    var errorDescription: String? {
      switch self {
      case .ingredientExists:
        return "Ingredient with the same name exists"
      case .categoryExists:
        return "Category with the same name exists"
      case .recipeExists:
        return "Recipe with the same name exists"
      }
    }
  }

    init(context: ModelContext) {
        modelContext = context
    }

    // Fetch Ingredients
    func fetchIngredients() -> [Ingredient] {
        let fetchDescriptor = FetchDescriptor<Ingredient>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }

    // Fetch Categories
    func fetchCategories() -> [Category] {
        let fetchDescriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }

    // Fetch Recipes
    func fetchRecipes() -> [Recipe] {
        let fetchDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    
  // MARK: - Load

    func load() {
        // Clear existing data to avoid duplication
        for ingredient in fetchIngredients() {
            modelContext.delete(ingredient)
        }
        for category in fetchCategories() {
            modelContext.delete(category)
        }
        for recipe in fetchRecipes() {
            modelContext.delete(recipe)
        }

        // Add Ingredients
        let pizzaDough = Ingredient(name: "Pizza Dough")
        let tomatoSauce = Ingredient(name: "Tomato Sauce")
        let mozzarellaCheese = Ingredient(name: "Mozzarella Cheese")
        let freshBasilLeaves = Ingredient(name: "Fresh Basil Leaves")
        let extraVirginOliveOil = Ingredient(name: "Extra Virgin Olive Oil")
        let salt = Ingredient(name: "Salt")
        let chickpeas = Ingredient(name: "Chickpeas")
        let tahini = Ingredient(name: "Tahini")
        let lemonJuice = Ingredient(name: "Lemon Juice")
        let garlic = Ingredient(name: "Garlic")
        let cumin = Ingredient(name: "Cumin")
        let water = Ingredient(name: "Water")
        let paprika = Ingredient(name: "Paprika")
        let parsley = Ingredient(name: "Parsley")
        let spaghetti = Ingredient(name: "Spaghetti")
        let eggs = Ingredient(name: "Eggs")
        let parmesanCheese = Ingredient(name: "Parmesan Cheese")
        let pancetta = Ingredient(name: "Pancetta")
        let blackPepper = Ingredient(name: "Black Pepper")
        let driedChickpeas = Ingredient(name: "Dried Chickpeas")
        let onions = Ingredient(name: "Onions")
        let cilantro = Ingredient(name: "Cilantro")
        let coriander = Ingredient(name: "Coriander")
        let bakingPowder = Ingredient(name: "Baking Powder")
        let chickenThighs = Ingredient(name: "Chicken Thighs")
        let yogurt = Ingredient(name: "Yogurt")
        let cardamom = Ingredient(name: "Cardamom")
        let cinnamon = Ingredient(name: "Cinnamon")
        let turmeric = Ingredient(name: "Turmeric")

        // Add Categories
        let italian = Category(name: "Italian")
        let middleEastern = Category(name: "Middle Eastern")

        // Add Recipes
        let margherita = Recipe(
            name: "Classic Margherita Pizza",
            summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
            category: italian,
            serving: 4,
            time: 50,
            ingredients: [
                RecipeIngredient(ingredient: pizzaDough, quantity: "1 ball"),
                RecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup"),
                RecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded"),
                RecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful"),
                RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
                RecipeIngredient(ingredient: salt, quantity: "Pinch")
            ],
            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
            imageData: UIImage(named: "margherita")?.pngData()
        )

        let spaghettiCarbonara = Recipe(
            name: "Spaghetti Carbonara",
            summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
            category: italian,
            serving: 4,
            time: 30,
            ingredients: [
                RecipeIngredient(ingredient: spaghetti, quantity: "400g"),
                RecipeIngredient(ingredient: eggs, quantity: "4"),
                RecipeIngredient(ingredient: parmesanCheese, quantity: "1 cup, grated"),
                RecipeIngredient(ingredient: pancetta, quantity: "200g, diced"),
                RecipeIngredient(ingredient: blackPepper, quantity: "To taste")
            ],
            instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
            imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
        )

        let hummus = Recipe(
            name: "Classic Hummus",
            summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
            category: middleEastern,
            serving: 6,
            time: 10,
            ingredients: [
                RecipeIngredient(ingredient: chickpeas, quantity: "1 can (15 oz)"),
                RecipeIngredient(ingredient: tahini, quantity: "1/4 cup"),
                RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
                RecipeIngredient(ingredient: garlic, quantity: "1 clove, minced"),
                RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
                RecipeIngredient(ingredient: cumin, quantity: "1/2 teaspoon"),
                RecipeIngredient(ingredient: salt, quantity: "To taste"),
                RecipeIngredient(ingredient: water, quantity: "2-3 tablespoons"),
                RecipeIngredient(ingredient: paprika, quantity: "For garnish"),
                RecipeIngredient(ingredient: parsley, quantity: "For garnish")
            ],
            instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
            imageData: UIImage(named: "hummus")?.pngData()
        )

        // Insert Ingredients, Categories, and Recipes into Context
        let allItems: [any PersistentModel] = [pizzaDough, tomatoSauce, mozzarellaCheese, freshBasilLeaves, extraVirginOliveOil, salt, chickpeas, tahini, lemonJuice, garlic, cumin, water, paprika, parsley, spaghetti, eggs, parmesanCheese, pancetta, blackPepper, driedChickpeas, onions, cilantro, coriander, bakingPowder, chickenThighs, yogurt, cardamom, cinnamon, turmeric, italian, middleEastern, margherita, spaghettiCarbonara, hummus]

        allItems.forEach { modelContext.insert($0) }
    }

  // MARK: - Categories

    func addCategory(name: String) throws {
        // Check if the category already exists
        guard fetchCategories().contains(where: { $0.name == name }) == false else {
            throw Error.categoryExists
        }

        // Create and insert the new category
        let newCategory = Category(name: name)
        modelContext.insert(newCategory)
    }

    // Delete an existing category
    func deleteCategory(id: UUID) {
        guard let category = fetchCategories().first(where: { $0.id == id}) else { return }
        modelContext.delete(category)

        // Remove category references from recipes
        let recipesWithCategory = fetchRecipes().filter { $0.category?.id == id }
        for recipe in recipesWithCategory {
            recipe.category = nil
        }
    }

    // Update an existing category
    func updateCategory(id: UUID, name: String) throws {
        guard fetchCategories().contains(where: { $0.name == name && $0.id != id }) == false else {
            throw Error.categoryExists
        }
        guard let category = fetchCategories().first(where: { $0.id == id }) else { return }
        category.name = name
    }

  // MARK: - Ingredients

  func addIngredient(name: String) throws {
    guard ingredients.contains(where: { $0.name == name }) == false else {
      throw Error.ingredientExists
    }
    ingredients.append(MockIngredient(name: name))
  }

  func deleteIngredient(id: MockIngredient.ID) {
    ingredients.removeAll(where: { $0.id == id })
  }

  func updateIngredient(id: MockIngredient.ID, name: String) throws {
    guard ingredients.contains(where: { $0.name == name && $0.id != id }) == false else {
      throw Error.ingredientExists
    }
    guard let index = ingredients.firstIndex(where: { $0.id == id }) else {
      return
    }
    ingredients[index].name = name
  }

  // MARK: - Recipes

  func addRecipe(
    name: String,
    summary: String,
    category: MockCategory?,
    serving: Int,
    time: Int,
    ingredients: [MockRecipeIngredient],
    instructions: String,
    imageData: Data?
  ) throws {
    guard recipes.contains(where: { $0.name == name }) == false else {
      throw Error.recipeExists
    }
    let recipe = MockRecipe(
      name: name,
      summary: summary,
      category: category,
      serving: serving,
      time: time,
      ingredients: ingredients,
      instructions: instructions,
      imageData: imageData
    )
    recipes.append(recipe)
    if let category, let index = categories.firstIndex(where: { $0.id == category.id }) {
      categories[index].recipes.append(recipe)
    }
  }

  func deleteRecipe(id: MockRecipe.ID) {
    recipes.removeAll(where: { $0.id == id })
    for cIndex in categories.indices {
      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    }
  }

  func updateRecipe(
    id: MockRecipe.ID,
    name: String,
    summary: String,
    category: MockCategory?,
    serving: Int,
    time: Int,
    ingredients: [MockRecipeIngredient],
    instructions: String,
    imageData: Data?
  ) throws {
    guard recipes.contains(where: { $0.name == name && $0.id != id }) == false else {
      throw Error.recipeExists
    }
    guard let index = recipes.firstIndex(where: { $0.id == id }) else {
      return
    }
    let recipe = MockRecipe(
      id: id,
      name: name,
      summary: summary,
      category: category,
      serving: serving,
      time: time,
      ingredients: ingredients,
      instructions: instructions,
      imageData: imageData
    )
    recipes[index] = recipe
    for cIndex in categories.indices {
      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    }
    if let cIndex = categories.firstIndex(where: { $0.id == category?.id }) {
      categories[cIndex].recipes.append(recipe)
    }
  }
}

struct StorageKey: EnvironmentKey {
  static let defaultValue = Storage()
}

extension EnvironmentValues {
  var storage: Storage {
    get { self[StorageKey.self] }
    set { self[StorageKey.self] = newValue }
  }
}
