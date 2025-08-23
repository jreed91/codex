import Foundation
import SwiftUI

class NutritionAI {
    func analyze(_ text: String) -> (calories: Int, macros: Macros) {
        let words = text.lowercased().split(separator: " ")
        var calories = 0
        var protein = 0
        var carbs = 0
        var fat = 0
        for (index, word) in words.enumerated() {
            if let value = Int(word) {
                if index + 1 < words.count {
                    let next = words[index + 1]
                    switch next {
                    case "calories", "cal" :
                        calories = value
                    case "protein", "p":
                        protein = value
                    case "carbs", "carb", "c":
                        carbs = value
                    case "fat", "f":
                        fat = value
                    default:
                        if calories == 0 { calories = value }
                    }
                } else if calories == 0 {
                    calories = value
                }
            }
        }
        return (calories, Macros(protein: protein, carbs: carbs, fat: fat))
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var totalCaloriesToday: Int = 0
    private let ai = NutritionAI()

    func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, isUser: true, calories: nil, macros: nil))
        let result = ai.analyze(trimmed)
        totalCaloriesToday += result.calories
        let response = "Logged \(result.calories) calories"
        messages.append(ChatMessage(text: response, isUser: false, calories: result.calories, macros: result.macros))
    }
}

