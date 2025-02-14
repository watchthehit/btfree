import Foundation
@testable import BetFree

@MainActor
class MockTimeProvider: TimeProvider {
    private var currentDate: Date
    private var fixedHour: Int?
    
    init(currentDate: Date = Date(), fixedHour: Int? = nil) {
        self.currentDate = currentDate
        self.fixedHour = fixedHour
    }
    
    func now() -> Date {
        return currentDate
    }
    
    func hour(from date: Date) -> Int {
        if let fixedHour = fixedHour {
            return fixedHour
        }
        return Calendar.current.component(.hour, from: date)
    }
    
    func setCurrentDate(_ date: Date) {
        self.currentDate = date
    }
    
    func setFixedHour(_ hour: Int) {
        self.fixedHour = hour
    }
} 