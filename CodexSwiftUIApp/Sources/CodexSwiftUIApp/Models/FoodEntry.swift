import Foundation

struct FoodEntry: Identifiable, Codable {
    let id: Int64
    let date: Date
    let mealType: MealType
    let foodName: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double

    init(id: Int64 = 0, date: Date = Date(), mealType: MealType, foodName: String,
         calories: Double, protein: Double, carbs: Double, fat: Double) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.foodName = foodName
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}
