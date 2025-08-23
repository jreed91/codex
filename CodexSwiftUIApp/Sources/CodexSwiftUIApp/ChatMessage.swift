import Foundation

struct Macros: Codable {
    var protein: Int
    var carbs: Int
    var fat: Int
}

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let calories: Int?
    let macros: Macros?
}

