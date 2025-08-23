import XCTest
@testable import CodexSwiftUIApp

final class CodexSwiftUIAppTests: XCTestCase {
    func testExample() throws {
        // Placeholder test
        XCTAssertTrue(true)
    }

    func testNutritionAIParsesInput() {
        let ai = NutritionAI()
        let result = ai.analyze("apple 95 calories 10 protein 20 carbs 5 fat")
        XCTAssertEqual(result.calories, 95)
        XCTAssertEqual(result.macros.protein, 10)
        XCTAssertEqual(result.macros.carbs, 20)
        XCTAssertEqual(result.macros.fat, 5)
    }

    func testChatViewModelAccumulatesCalories() {
        let vm = ChatViewModel()
        vm.send("100 calories")
        vm.send("200 calories")
        XCTAssertEqual(vm.totalCaloriesToday, 300)
    }
}

