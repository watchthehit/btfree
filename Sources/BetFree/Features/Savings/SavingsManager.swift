import Foundation

public class SavingsManager: ObservableObject {
    @Published public private(set) var totalSaved: Double = 0
    @Published public private(set) var dailyAverage: Double = 0
    @Published public private(set) var streakDays: Int = 0
    @Published public private(set) var lastUpdate: Date?
    
    private let defaults = UserDefaults.standard
    private let savingsKey = "BFSavings"
    private let streakKey = "BFSavingsStreak"
    private let lastUpdateKey = "BFSavingsLastUpdate"
    
    public init() {
        loadSavings()
    }
    
    private func loadSavings() {
        totalSaved = defaults.double(forKey: savingsKey)
        streakDays = defaults.integer(forKey: streakKey)
        lastUpdate = defaults.object(forKey: lastUpdateKey) as? Date
        calculateDailyAverage()
    }
    
    private func saveSavings() {
        defaults.set(totalSaved, forKey: savingsKey)
        defaults.set(streakDays, forKey: streakKey)
        defaults.set(lastUpdate, forKey: lastUpdateKey)
    }
    
    private func calculateDailyAverage() {
        guard let first = lastUpdate else { return }
        let days = Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 1
        dailyAverage = totalSaved / Double(max(1, days))
    }
    
    public func addSaving(_ amount: Double) {
        totalSaved += amount
        updateStreak()
        calculateDailyAverage()
        saveSavings()
        
        // Trigger haptic feedback for milestone achievements
        if let milestone = checkMilestone() {
            NotificationCenter.default.post(
                name: .savingsMilestoneReached,
                object: nil,
                userInfo: ["milestone": milestone]
            )
        }
    }
    
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let last = lastUpdate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let dayDiff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if dayDiff == 1 {
                // Consecutive day
                streakDays += 1
            } else if dayDiff > 1 {
                // Streak broken
                streakDays = 1
            }
        } else {
            // First saving
            streakDays = 1
        }
        
        lastUpdate = today
    }
    
    private func checkMilestone() -> Int? {
        let milestones = [100, 500, 1000, 5000, 10000]
        let previousTotal = totalSaved - (totalSaved.truncatingRemainder(dividingBy: 1))
        
        for milestone in milestones {
            if previousTotal < Double(milestone) && totalSaved >= Double(milestone) {
                return milestone
            }
        }
        return nil
    }
    
    public func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

// MARK: - Notification Names
public extension Notification.Name {
    static let savingsMilestoneReached = Notification.Name("BFSavingsMilestoneReached")
}
