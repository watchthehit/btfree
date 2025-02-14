import XCTest
@testable import BetFree

@MainActor
final class BetFreeTests: XCTestCase {
    func testOnboardingViewModel() async throws {
        let viewModel = OnboardingViewModel()
        XCTAssertEqual(viewModel.currentStep, 0)
        XCTAssertEqual(viewModel.steps.count, 6)
        XCTAssertTrue(viewModel.canProceed)
    }
} 