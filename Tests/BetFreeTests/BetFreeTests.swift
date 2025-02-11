import XCTest
@testable import BetFree

final class BetFreeTests: XCTestCase {
    func testOnboardingViewModel() throws {
        let viewModel = OnboardingViewModel()
        XCTAssertEqual(viewModel.currentStep, 0)
        XCTAssertEqual(viewModel.steps.count, 5)
        XCTAssertTrue(viewModel.canProceed)
    }
} 