import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var input: String = ""

    var body: some View {
        VStack {
            Text("Today's calories: \(viewModel.totalCaloriesToday)")
                .font(.headline)
                .padding()
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isUser { Spacer() }
                        VStack(alignment: .leading) {
                            Text(message.text)
                            if let calories = message.calories {
                                Text("Calories: \(calories)")
                                    .font(.caption)
                            }
                            if let macros = message.macros {
                                Text("P: \(macros.protein)g C: \(macros.carbs)g F: \(macros.fat)g")
                                    .font(.caption2)
                            }
                        }
                        .padding(8)
                        .background(message.isUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        if !message.isUser { Spacer() }
                    }
                    .padding(.vertical, 2)
                }
            }
            HStack {
                TextField("Describe your food", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.send(input)
                    input = ""
                }
                .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

