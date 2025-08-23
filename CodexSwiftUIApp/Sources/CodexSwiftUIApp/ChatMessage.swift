import Foundation

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let calories: Int?
    let macros: Macros?
}

