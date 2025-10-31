import Foundation
import SQLite

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    private var db: Connection?

    // Table definition
    private let foodEntries = Table("food_entries")
    private let id = Expression<Int64>("id")
    private let date = Expression<Date>("date")
    private let mealType = Expression<String>("meal_type")
    private let foodName = Expression<String>("food_name")
    private let calories = Expression<Double>("calories")
    private let protein = Expression<Double>("protein")
    private let carbs = Expression<Double>("carbs")
    private let fat = Expression<Double>("fat")

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            db = try Connection("\(path)/food_tracker.sqlite3")
            try createTable()
        } catch {
            print("Database initialization failed: \(error)")
        }
    }

    private func createTable() throws {
        try db?.run(foodEntries.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(date)
            t.column(mealType)
            t.column(foodName)
            t.column(calories)
            t.column(protein)
            t.column(carbs)
            t.column(fat)
        })
    }

    // MARK: - CRUD Operations

    func addFoodEntry(_ entry: FoodEntry) throws -> Int64 {
        guard let db = db else { throw DatabaseError.connectionFailed }

        let insert = foodEntries.insert(
            date <- entry.date,
            mealType <- entry.mealType.rawValue,
            foodName <- entry.foodName,
            calories <- entry.calories,
            protein <- entry.protein,
            carbs <- entry.carbs,
            fat <- entry.fat
        )

        return try db.run(insert)
    }

    func getFoodEntries(for date: Date) throws -> [FoodEntry] {
        guard let db = db else { throw DatabaseError.connectionFailed }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        var entries: [FoodEntry] = []

        let query = foodEntries.filter(self.date >= startOfDay && self.date < endOfDay)

        for row in try db.prepare(query) {
            let entry = FoodEntry(
                id: row[id],
                date: row[self.date],
                mealType: MealType(rawValue: row[mealType]) ?? .snack,
                foodName: row[foodName],
                calories: row[calories],
                protein: row[protein],
                carbs: row[carbs],
                fat: row[fat]
            )
            entries.append(entry)
        }

        return entries
    }

    func updateFoodEntry(_ entry: FoodEntry) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }

        let foodEntry = foodEntries.filter(id == entry.id)
        try db.run(foodEntry.update(
            date <- entry.date,
            mealType <- entry.mealType.rawValue,
            foodName <- entry.foodName,
            calories <- entry.calories,
            protein <- entry.protein,
            carbs <- entry.carbs,
            fat <- entry.fat
        ))
    }

    func deleteFoodEntry(_ entryId: Int64) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }

        let foodEntry = foodEntries.filter(id == entryId)
        try db.run(foodEntry.delete())
    }

    func getEntriesInDateRange(from startDate: Date, to endDate: Date) throws -> [FoodEntry] {
        guard let db = db else { throw DatabaseError.connectionFailed }

        var entries: [FoodEntry] = []

        let query = foodEntries.filter(date >= startDate && date < endDate)
            .order(self.date.desc)

        for row in try db.prepare(query) {
            let entry = FoodEntry(
                id: row[id],
                date: row[self.date],
                mealType: MealType(rawValue: row[mealType]) ?? .snack,
                foodName: row[foodName],
                calories: row[calories],
                protein: row[protein],
                carbs: row[carbs],
                fat: row[fat]
            )
            entries.append(entry)
        }

        return entries
    }
}

enum DatabaseError: Error {
    case connectionFailed
    case insertFailed
    case queryFailed
}
