import Foundation

class FoodParserService {
    // This service will use Apple Intelligence to parse food text
    // For iOS 26, we'll use the Intelligence framework

    func parseFood(from text: String) async throws -> [FoodEntry] {
        // Use Apple Intelligence to parse the food text
        // This is a placeholder for the actual Apple Intelligence integration
        // which will be available through the Intelligence framework in iOS 26

        // For now, we'll implement a basic parser that demonstrates the structure
        // In production, this would call Apple's Intelligence APIs

        let prompt = """
        Parse the following food log entry and extract food items with their nutritional information.
        Return JSON array with: foodName, calories (number), protein (g), carbs (g), fat (g), mealType (breakfast/lunch/dinner/snack).

        User input: \(text)

        Provide your best estimate for nutritional values based on common portion sizes.
        """

        // TODO: Replace with actual Apple Intelligence API call
        // For now, return a mock response to demonstrate structure
        let parsedEntries = try await mockParsing(text: text)

        return parsedEntries
    }

    // Mock implementation - replace with actual Apple Intelligence integration
    private func mockParsing(text: String) async throws -> [FoodEntry] {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        let lowercased = text.lowercased()

        // Determine meal type from text or time
        let mealType = determineMealType(from: text)

        var entries: [FoodEntry] = []

        // Simple keyword-based parsing (replace with Apple Intelligence)
        let foodKeywords: [(String, Double, Double, Double, Double)] = [
            ("egg", 70, 6, 1, 5),
            ("eggs", 140, 12, 2, 10),
            ("toast", 80, 3, 15, 1),
            ("chicken", 165, 31, 0, 4),
            ("rice", 130, 2.7, 28, 0.3),
            ("apple", 95, 0.5, 25, 0.3),
            ("banana", 105, 1.3, 27, 0.4),
            ("salad", 50, 2, 8, 1),
            ("pasta", 200, 7, 40, 1.5),
            ("pizza", 285, 12, 36, 10),
            ("burger", 354, 20, 33, 17),
            ("sandwich", 250, 15, 30, 8),
            ("yogurt", 100, 5, 12, 2.5),
            ("oatmeal", 150, 5, 27, 3),
            ("protein shake", 200, 25, 10, 3),
            ("milk", 150, 8, 12, 8),
            ("coffee", 5, 0.3, 0, 0),
        ]

        for (food, cal, prot, carb, ft) in foodKeywords {
            if lowercased.contains(food) {
                entries.append(FoodEntry(
                    id: 0,
                    date: Date(),
                    mealType: mealType,
                    foodName: food.capitalized,
                    calories: cal,
                    protein: prot,
                    carbs: carb,
                    fat: ft
                ))
            }
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
