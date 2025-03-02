import XCTest
@testable import BetFreeApp

final class BetFreeAppTests: XCTestCase {
    func testBFColorsExistence() {
        // Simply test that BFColors properties return valid colors
        XCTAssertNotNil(BFColors.primary)
        XCTAssertNotNil(BFColors.secondary)
        XCTAssertNotNil(BFColors.accent)
        XCTAssertNotNil(BFColors.calm)
        XCTAssertNotNil(BFColors.focus)
        XCTAssertNotNil(BFColors.hope)
        XCTAssertNotNil(BFColors.success)
        XCTAssertNotNil(BFColors.warning)
        XCTAssertNotNil(BFColors.error)
        XCTAssertNotNil(BFColors.background)
        XCTAssertNotNil(BFColors.cardBackground)
        XCTAssertNotNil(BFColors.textPrimary)
        XCTAssertNotNil(BFColors.textSecondary)
        XCTAssertNotNil(BFColors.textTertiary)
        XCTAssertNotNil(BFColors.divider)
    }
    
    func testGradientFunctions() {
        // Test that gradient functions return valid gradients
        XCTAssertNotNil(BFColors.primaryGradient())
        XCTAssertNotNil(BFColors.brandGradient())
        XCTAssertNotNil(BFColors.energyGradient())
        XCTAssertNotNil(BFColors.progressGradient())
    }
} 