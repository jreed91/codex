import Foundation

struct Macros: Codable {
    var protein: Int
    var carbs: Int
    var fat: Int
}

protocol NutritionService {
    func analyze(_ text: String) async throws -> (calories: Int, macros: Macros)
}

struct OpenAINutritionService: NutritionService {
    private let apiKey: String

    init(apiKey: String = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "") {
        self.apiKey = apiKey
    }

    private struct ChatRequest: Encodable {
        struct Message: Encodable {
            let role: String
            let content: String
        }
        struct ResponseFormat: Encodable {
            let type: String
        }
        let model: String
        let messages: [Message]
        let response_format: ResponseFormat
    }

    private struct ChatResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                let content: String
            }
            let message: Message
        }
        let choices: [Choice]
    }

    private struct AIResult: Decodable {
        let calories: Int
        let protein: Int
        let carbs: Int
        let fat: Int
    }

    func analyze(_ text: String) async throws -> (calories: Int, macros: Macros) {
        guard !apiKey.isEmpty else {
            throw NSError(domain: "OpenAI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing API key"])
        }
        let prompt = """
        Extract the total calories and macronutrients (protein, carbs, fat) from this description: \(text).
        Respond only in JSON with keys calories, protein, carbs, fat.
        """
        let requestBody = ChatRequest(
            model: "gpt-4o-mini",
            messages: [.init(role: "user", content: prompt)],
            response_format: .init(type: "json_object")
        )
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content,
              let contentData = content.data(using: .utf8) else {
            throw NSError(domain: "OpenAI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        let ai = try JSONDecoder().decode(AIResult.self, from: contentData)
        return (ai.calories, Macros(protein: ai.protein, carbs: ai.carbs, fat: ai.fat))
    }
}

