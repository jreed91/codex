import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()

                // Input Area
                HStack(spacing: 12) {
                    TextField("Log your food...", text: $messageText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...5)

                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Food Logger")
        }
    }

    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        messageText = ""
        viewModel.sendMessage(text)
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !message.isUser {
                Spacer()
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let foodParser = FoodParserService()

    init() {
        // Welcome message
        messages.append(ChatMessage(
            text: "Hi! Tell me what you ate and I'll help you track it. For example: 'I had 2 eggs and toast for breakfast'",
            isUser: false,
            timestamp: Date()
        ))
    }

    func sendMessage(_ text: String) {
        // Add user message
        messages.append(ChatMessage(text: text, isUser: true, timestamp: Date()))

        // Parse food using Apple Intelligence
        Task {
            do {
                let entries = try await foodParser.parseFood(from: text)

                if entries.isEmpty {
                    addSystemMessage("I couldn't identify any food items. Could you try again with more details?")
                } else {
                    // Add entries to database
                    for entry in entries {
                        try DatabaseManager.shared.addFoodEntry(entry)
                    }

                    // Create response message
                    let itemsList = entries.map { "\($0.foodName): \(String(format: "%.0f", $0.calories)) kcal" }.joined(separator: "\n")
                    addSystemMessage("Logged:\n\(itemsList)")
                }
            } catch FoodParserError.modelUnavailable {
                addSystemMessage("Apple Intelligence is not available on this device. Please check your settings or device compatibility.")
            } catch {
                addSystemMessage("Sorry, I had trouble processing that. Please try again.")
            }
        }
    }

    private func addSystemMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: false, timestamp: Date()))
    }
}

#Preview {
    ChatView()
}
