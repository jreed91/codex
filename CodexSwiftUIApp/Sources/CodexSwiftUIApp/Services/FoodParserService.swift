import Foundation
import FoundationModels

@Generable
struct ParsedFoodItems: Codable {
    let items: [ParsedFoodItem]
}

@Generable
struct ParsedFoodItem: Codable {
    let foodName: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}

class FoodParserService {
    private let model = SystemLanguageModel.default

    func parseFood(from text: String) async throws -> [FoodEntry] {
        // Check if model is available
        guard case .available = model.availability else {
            throw FoodParserError.modelUnavailable
        }

        // Determine meal type from text or time
        let mealType = determineMealType(from: text)

        // Create session
        let session = LanguageModelSession()

        // Create prompt for structured food parsing
        let prompt = """
        You are a nutritionist assistant. Parse the following food log entry and extract all food items with their nutritional information.

        User input: "\(text)"

        For each food item mentioned, provide:
        - foodName: The name of the food item
        - calories: Estimated calories (as a number)
        - protein: Estimated protein in grams (as a number)
        - carbs: Estimated carbohydrates in grams (as a number)
        - fat: Estimated fat in grams (as a number)

        Base estimates on standard portion sizes. If quantities are mentioned (e.g., "2 eggs"), calculate totals accordingly.
        Return all identified food items in an array.
        """

        // Use guided generation to get structured output
        let response = try await session.respond(to: prompt, generating: ParsedFoodItems.self)

        // Convert parsed items to FoodEntry objects
        let entries = response.content.items.map { item in
            FoodEntry(
                id: 0,
                date: Date(),
                mealType: mealType,
                foodName: item.foodName,
                calories: item.calories,
                protein: item.protein,
                carbs: item.carbs,
                fat: item.fat
            )
        }

        return entries
    }

    private func determineMealType(from text: String) -> MealType {
        let lowercased = text.lowercased()

        if lowercased.contains("breakfast") {
            return .breakfast
        } else if lowercased.contains("lunch") {
            return .lunch
        } else if lowercased.contains("dinner") {
            return .dinner
        } else if lowercased.contains("snack") {
            return .snack
        }

        // Determine by time of day
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11:
            return .breakfast
        case 11..<15:
            return .lunch
        case 15..<18:
            return .snack
        default:
            return .dinner
        }
    }
}

enum FoodParserError: Error {
    case modelUnavailable
    case parsingFailed
}
