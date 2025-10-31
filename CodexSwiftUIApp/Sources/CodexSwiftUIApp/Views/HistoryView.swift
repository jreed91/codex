import SwiftUI
import Charts

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedPeriod: TimePeriod = .week

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Period Picker
                Picker("Period", selection: $selectedPeriod) {
                    Text("Week").tag(TimePeriod.week)
                    Text("Month").tag(TimePeriod.month)
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedPeriod) { _ in
                    viewModel.loadHistory(for: selectedPeriod)
                }

                ScrollView {
                    VStack(spacing: 20) {
                        // Average Stats
                        if !viewModel.dailyStats.isEmpty {
                            VStack(spacing: 16) {
                                Text("Average Daily Intake")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(spacing: 20) {
                                    StatCard(
                                        title: "Calories",
                                        value: String(format: "%.0f", viewModel.averageCalories),
                                        unit: "kcal",
                                        color: .blue
                                    )
                                    StatCard(
                                        title: "Protein",
                                        value: String(format: "%.0f", viewModel.averageProtein),
                                        unit: "g",
                                        color: .blue
                                    )
                                }

                                HStack(spacing: 20) {
                                    StatCard(
                                        title: "Carbs",
                                        value: String(format: "%.0f", viewModel.averageCarbs),
                                        unit: "g",
                                        color: .orange
                                    )
                                    StatCard(
                                        title: "Fat",
                                        value: String(format: "%.0f", viewModel.averageFat),
                                        unit: "g",
                                        color: .pink
                                    )
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                            // Calorie Chart
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calorie Trend")
                                    .font(.headline)

                                Chart(viewModel.dailyStats) { stat in
                                    BarMark(
                                        x: .value("Date", stat.date, unit: .day),
                                        y: .value("Calories", stat.calories)
                                    )
                                    .foregroundStyle(.blue)
                                }
                                .frame(height: 200)
                                .chartXAxis {
                                    AxisMarks(values: .stride(by: .day, count: selectedPeriod == .week ? 1 : 5))
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                            // Daily Breakdown
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Daily Breakdown")
                                    .font(.headline)

                                ForEach(viewModel.dailyStats) { stat in
                                    DailyStatRow(stat: stat)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 60))
                                    .foregroundColor(.secondary)
                                Text("No data for this period")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("Start logging your meals to see your history")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(40)
                        }
                    }
                    .padding()
                }

                .navigationTitle("History")
                .onAppear {
                    viewModel.loadHistory(for: selectedPeriod)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(color)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct DailyStatRow: View {
    let stat: DailyStat

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.date, style: .date)
                .font(.subheadline)
                .bold()

            HStack(spacing: 16) {
                Label(String(format: "%.0f kcal", stat.calories), systemImage: "flame.fill")
                    .font(.caption)
                    .foregroundColor(.blue)

                Label(String(format: "%.0fg", stat.protein), systemImage: "p.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)

                Label(String(format: "%.0fg", stat.carbs), systemImage: "c.circle.fill")
                    .font(.caption)
                    .foregroundColor(.orange)

                Label(String(format: "%.0fg", stat.fat), systemImage: "f.circle.fill")
                    .font(.caption)
                    .foregroundColor(.pink)
            }
        }
        .padding(.vertical, 8)
    }
}

enum TimePeriod {
    case week
    case month
}

struct DailyStat: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var dailyStats: [DailyStat] = []

    var averageCalories: Double {
        guard !dailyStats.isEmpty else { return 0 }
        return dailyStats.reduce(0) { $0 + $1.calories } / Double(dailyStats.count)
    }

    var averageProtein: Double {
        guard !dailyStats.isEmpty else { return 0 }
        return dailyStats.reduce(0) { $0 + $1.protein } / Double(dailyStats.count)
    }

    var averageCarbs: Double {
        guard !dailyStats.isEmpty else { return 0 }
        return dailyStats.reduce(0) { $0 + $1.carbs } / Double(dailyStats.count)
    }

    var averageFat: Double {
        guard !dailyStats.isEmpty else { return 0 }
        return dailyStats.reduce(0) { $0 + $1.fat } / Double(dailyStats.count)
    }

    func loadHistory(for period: TimePeriod) {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate: Date

        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .day, value: -30, to: endDate)!
        }

        do {
            let entries = try DatabaseManager.shared.getEntriesInDateRange(from: startDate, to: endDate)

            // Group by day
            var dailyGroups: [Date: [FoodEntry]] = [:]

            for entry in entries {
                let dayStart = calendar.startOfDay(for: entry.date)
                dailyGroups[dayStart, default: []].append(entry)
            }

            // Calculate daily stats
            dailyStats = dailyGroups.map { date, entries in
                DailyStat(
                    date: date,
                    calories: entries.reduce(0) { $0 + $1.calories },
                    protein: entries.reduce(0) { $0 + $1.protein },
                    carbs: entries.reduce(0) { $0 + $1.carbs },
                    fat: entries.reduce(0) { $0 + $1.fat }
                )
            }.sorted { $0.date > $1.date }

        } catch {
            print("Failed to load history: \(error)")
            dailyStats = []
        }
    }
}

#Preview {
    HistoryView()
}
