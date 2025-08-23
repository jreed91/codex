import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var totalCaloriesToday: Int = 0
    private let service: NutritionService

    init(service: NutritionService = OpenAINutritionService()) {
        self.service = service
    }

    func send(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, isUser: true, calories: nil, macros: nil))
        do {
            let result = try await service.analyze(trimmed)
            totalCaloriesToday += result.calories
            let response = "Logged \(result.calories) calories"
            messages.append(ChatMessage(text: response, isUser: false, calories: result.calories, macros: result.macros))
        } catch {
            messages.append(ChatMessage(text: "Failed to analyze", isUser: false, calories: nil, macros: nil))
        }
    }
}

