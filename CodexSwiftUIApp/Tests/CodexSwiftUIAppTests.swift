import XCTest
@testable import CodexSwiftUIApp

final class CodexSwiftUIAppTests: XCTestCase {
    @MainActor
    func testChatViewModelAccumulatesCalories() async {
        let service = MockNutritionService(responses: [
            (100, Macros(protein: 0, carbs: 0, fat: 0)),
            (200, Macros(protein: 0, carbs: 0, fat: 0))
        ])
        let vm = ChatViewModel(service: service)
        await vm.send("first")
        await vm.send("second")
        XCTAssertEqual(vm.totalCaloriesToday, 300)
        XCTAssertEqual(vm.messages.count, 4)
    }

    @MainActor
    func testChatViewModelStoresMacros() async {
        let service = MockNutritionService(responses: [
            (150, Macros(protein: 10, carbs: 20, fat: 5))
        ])
        let vm = ChatViewModel(service: service)
        await vm.send("meal")
        let aiMessage = vm.messages.last
        XCTAssertEqual(aiMessage?.macros?.protein, 10)
        XCTAssertEqual(aiMessage?.macros?.carbs, 20)
        XCTAssertEqual(aiMessage?.macros?.fat, 5)
    }
}

private final class MockNutritionService: NutritionService {
    var responses: [(Int, Macros)]
    init(responses: [(Int, Macros)]) { self.responses = responses }
    func analyze(_ text: String) async throws -> (calories: Int, macros: Macros) {
        return responses.removeFirst()
    }
}

