import Foundation
import BetFreeModels

public class SavingsManager: ObservableObject {
    @Published public private(set) var totalSaved: Double = 0
    @Published public private(set) var dailyAverage: Double = 0
    @Published public private(set) var streakDays: Int = 0
    @Published public private(set) var lastUpdate: Date?
    @Published public private(set) var recentSavings: [Saving] = []
    
    private let defaults = UserDefaults.standard
    private let savingsKey = "BFSavings"
    private let streakKey = "BFSavingsStreak"
    private let lastUpdateKey = "BFSavingsLastUpdate"
    private let savingsByDateKey = "BFSavingsByDate"
    private var savingsByDate: [String: Double] = [:]
    
    public init() {
        loadSavings()
    }
    
    private func loadSavings() {
        totalSaved = defaults.double(forKey: savingsKey)
        streakDays = defaults.integer(forKey: streakKey)
        lastUpdate = defaults.object(forKey: lastUpdateKey) as? Date
        if let savedDict = defaults.dictionary(forKey: savingsByDateKey) as? [String: Double] {
            savingsByDate = savedDict
        }
        
        // Load recent savings
        if let savedData = defaults.data(forKey: "recentSavings"),
           let decoded = try? JSONDecoder().decode([Saving].self, from: savedData) {
            recentSavings = decoded
        }
        
        calculateDailyAverage()
    }
    
    private func saveSavings() {
        defaults.set(totalSaved, forKey: savingsKey)
        defaults.set(streakDays, forKey: streakKey)
        defaults.set(lastUpdate, forKey: lastUpdateKey)
        defaults.set(savingsByDate, forKey: savingsByDateKey)
        
        // Save recent savings
        if let encoded = try? JSONEncoder().encode(recentSavings) {
            defaults.set(encoded, forKey: "recentSavings")
        }
    }
    
    private func calculateDailyAverage() {
        guard let first = lastUpdate else { return }
        let days = Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 1
        dailyAverage = totalSaved / Double(max(1, days))
    }
    
    public func addSaving(_ amount: Double, sport: Sport = .baseball) {
        totalSaved += amount
        
        // Save amount for today
        let dateString = Self.dateFormatter.string(from: Date())
        savingsByDate[dateString] = (savingsByDate[dateString] ?? 0) + amount
        
        // Add to recent savings
        let saving = Saving(amount: amount, date: Date(), sport: sport, note: nil)
        recentSavings.insert(saving, at: 0)
        
        // Keep only last 10 savings
        if recentSavings.count > 10 {
            recentSavings.removeLast()
        }
        
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
    
    public func savings(for date: Date) -> Double {
        let dateString = Self.dateFormatter.string(from: date)
        return savingsByDate[dateString] ?? 0
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
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

// MARK: - Notification Names
public extension Notification.Name {
    static let savingsMilestoneReached = Notification.Name("BFSavingsMilestoneReached")
}
