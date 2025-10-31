import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        NavigationView {
            List {
                // Summary Section
                Section("Daily Summary") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total Calories")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.0f kcal", viewModel.totalCalories))
                                .font(.title2)
                                .bold()
                        }

                        Divider()

                        HStack(spacing: 20) {
                            MacroDisplay(name: "Protein", value: viewModel.totalProtein, unit: "g", color: .blue)
                            MacroDisplay(name: "Carbs", value: viewModel.totalCarbs, unit: "g", color: .orange)
                            MacroDisplay(name: "Fat", value: viewModel.totalFat, unit: "g", color: .pink)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Meals Sections
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Section(mealType.rawValue) {
                        let entries = viewModel.entries.filter { $0.mealType == mealType }

                        if entries.isEmpty {
                            Text("No items logged")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(entries) { entry in
                                FoodEntryRow(entry: entry, onDelete: {
                                    viewModel.deleteEntry(entry)
                                })
                            }
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .onAppear {
                viewModel.loadEntries()
            }
            .refreshable {
                viewModel.loadEntries()
            }
        }
    }
}

struct MacroDisplay: View {
    let name: String
    let value: Double
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.0f", value))
                .font(.title3)
                .bold()
                .foregroundColor(color)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.foodName)
                    .font(.body)
                Text("\(String(format: "%.0f", entry.calories)) kcal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                Text("P: \(String(format: "%.0f", entry.protein))g")
                    .font(.caption2)
                    .foregroundColor(.blue)
                Text("C: \(String(format: "%.0f", entry.carbs))g")
                    .font(.caption2)
                    .foregroundColor(.orange)
                Text("F: \(String(format: "%.0f", entry.fat))g")
                    .font(.caption2)
                    .foregroundColor(.pink)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

@MainActor
class TodayViewModel: ObservableObject {
    @Published var entries: [FoodEntry] = []

    var totalCalories: Double {
        entries.reduce(0) { $0 + $1.calories }
    }

    var totalProtein: Double {
        entries.reduce(0) { $0 + $1.protein }
    }

    var totalCarbs: Double {
        entries.reduce(0) { $0 + $1.carbs }
    }

    var totalFat: Double {
        entries.reduce(0) { $0 + $1.fat }
    }

    func loadEntries() {
        do {
            entries = try DatabaseManager.shared.getFoodEntries(for: Date())
        } catch {
            print("Failed to load entries: \(error)")
        }
    }

    func deleteEntry(_ entry: FoodEntry) {
        do {
            try DatabaseManager.shared.deleteFoodEntry(entry.id)
            loadEntries()
        } catch {
            print("Failed to delete entry: \(error)")
        }
    }
}

#Preview {
    TodayView()
}
