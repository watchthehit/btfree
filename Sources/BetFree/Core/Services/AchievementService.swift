import Foundation
import CoreData

public enum AchievementError: Error {
    case invalidStreak
    case invalidSavings
    case achievementNotFound
}

@MainActor
public protocol TimeProvider {
    func now() -> Date
    func hour(from date: Date) -> Int
}

public class DefaultTimeProvider: TimeProvider {
    public nonisolated init() {}
    
    public func now() -> Date {
        return Date()
    }
    
    public func hour(from date: Date) -> Int {
        return Calendar.current.component(.hour, from: date)
    }
}

@MainActor
public final class AchievementService {
    private let context: NSManagedObjectContext
    private let timeProvider: TimeProvider
    
    public init(context: NSManagedObjectContext, timeProvider: TimeProvider = DefaultTimeProvider()) {
        self.context = context
        self.timeProvider = timeProvider
    }
    
    private func createFetchRequest() -> NSFetchRequest<Achievement> {
        let request = NSFetchRequest<Achievement>(entityName: Achievement.entityName)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Achievement.title, ascending: true)]
        return request
    }
    
    public func fetchAchievements() async throws -> [Achievement] {
        let request = self.createFetchRequest()
        return try context.fetch(request)
    }
    
    public func reset() {
        // Reset any internal state if needed
    }
    
    public func initializeDefaultAchievementsIfNeeded() async throws {
        let achievements = try await fetchAchievements()
        guard achievements.isEmpty else { return }
        
        try Achievement.createDefaultAchievements(context: context)
    }
    
    public func checkProgress(
        streak: Int32,
        savings: Double,
        checkInTime: Date? = nil,
        transactionCount: Int = 0,
        daysUnderLimit: Int = 0,
        goalReached: Bool = false
    ) async throws -> [Achievement] {
        guard streak >= 0 else {
            throw AchievementError.invalidStreak
        }
        
        guard savings >= 0 else {
            throw AchievementError.invalidSavings
        }
        
        let request = self.createFetchRequest()
        let achievements = try context.fetch(request)
        var hasChanges = false
        var unlockedAchievements: [Achievement] = []
        
        // Process achievements in a specific order to ensure proper unlocking
        let orderedAchievements = achievements.sorted { a1, a2 in
            let order = [
                "First Step",
                "Week Warrior",
                "Monthly Marvel",
                "Quarterly Victor",
                "Annual Legend",
                "Money Master",
                "Savings Champion",
                "Wealth Builder",
                "Fortune Maker",
                "Early Bird",
                "Night Owl",
                "Consistency King",
                "Smart Saver",
                "Budget Master",
                "Goal Getter"
            ]
            let index1 = order.firstIndex(of: a1.title) ?? Int.max
            let index2 = order.firstIndex(of: a2.title) ?? Int.max
            return index1 < index2
        }
        
        // Track which achievements are unlocked in this session
        var unlockedInThisSession = Set<String>()
        
        for achievement in orderedAchievements {
            let wasUnlocked = achievement.isUnlocked
            let previousProgress = achievement.progress
            var newProgress = previousProgress
            
            switch achievement.title {
            case "First Step":
                newProgress = streak >= 1 ? 1.0 : 0.0
                
            case "Week Warrior":
                newProgress = min(Double(streak) / 7.0, 1.0)
                
            case "Monthly Marvel":
                // Only check if Week Warrior is unlocked
                let weekWarrior = achievements.first { $0.title == "Week Warrior" }
                if weekWarrior?.isUnlocked == true || unlockedInThisSession.contains("Week Warrior") {
                    newProgress = min(Double(streak) / 30.0, 1.0)
                }
                
            case "Quarterly Victor":
                // Only check if Monthly Marvel is unlocked
                let monthlyMarvel = achievements.first { $0.title == "Monthly Marvel" }
                if monthlyMarvel?.isUnlocked == true || unlockedInThisSession.contains("Monthly Marvel") {
                    newProgress = min(Double(streak) / 90.0, 1.0)
                }
                
            case "Annual Legend":
                // Only check if Quarterly Victor is unlocked
                let quarterlyVictor = achievements.first { $0.title == "Quarterly Victor" }
                if quarterlyVictor?.isUnlocked == true || unlockedInThisSession.contains("Quarterly Victor") {
                    newProgress = min(Double(streak) / 365.0, 1.0)
                }
                
            case "Money Master":
                newProgress = min(savings / 100.0, 1.0)
                
            case "Savings Champion":
                // Only check if Money Master is unlocked
                let moneyMaster = achievements.first { $0.title == "Money Master" }
                if moneyMaster?.isUnlocked == true || unlockedInThisSession.contains("Money Master") {
                    newProgress = min(savings / 1000.0, 1.0)
                }
                
            case "Wealth Builder":
                // Only check if Savings Champion is unlocked
                let savingsChampion = achievements.first { $0.title == "Savings Champion" }
                if savingsChampion?.isUnlocked == true || unlockedInThisSession.contains("Savings Champion") {
                    newProgress = min(savings / 5000.0, 1.0)
                }
                
            case "Fortune Maker":
                // Only check if Wealth Builder is unlocked
                let wealthBuilder = achievements.first { $0.title == "Wealth Builder" }
                if wealthBuilder?.isUnlocked == true || unlockedInThisSession.contains("Wealth Builder") {
                    newProgress = min(savings / 10000.0, 1.0)
                }
                
            case "Early Bird":
                if let checkInTime = checkInTime {
                    let hour = self.timeProvider.hour(from: checkInTime)
                    if hour < 9 {
                        newProgress = min(previousProgress + 0.2, 1.0)
                    }
                }
                
            case "Night Owl":
                if let checkInTime = checkInTime {
                    let hour = self.timeProvider.hour(from: checkInTime)
                    if hour >= 20 {
                        newProgress = min(previousProgress + 0.2, 1.0)
                    }
                }
                
            case "Consistency King":
                // Only check if Week Warrior is unlocked
                let weekWarrior = achievements.first { $0.title == "Week Warrior" }
                if let checkInTime = checkInTime, 
                   (weekWarrior?.isUnlocked == true || unlockedInThisSession.contains("Week Warrior")),
                   streak >= 7 {
                    // Check if this check-in is at a consistent time
                    let hour = self.timeProvider.hour(from: checkInTime)
                    let lastProgress = previousProgress
                    
                    // For first check-in, store the hour
                    if lastProgress == 0.0 {
                        newProgress = 0.2 // Start progress
                        achievement.lastCheckInHour = Int16(hour)
                    } else {
                        // Get stored check-in hour
                        let lastHour = Int(achievement.lastCheckInHour)
                        
                        // If within 1 hour of previous check-in time, increase progress
                        if abs(hour - lastHour) <= 1 {
                            newProgress = min(previousProgress + 0.2, 1.0) // 5 consistent check-ins needed
                        } else {
                            // Reset progress if check-in time is inconsistent
                            newProgress = 0.0
                        }
                        
                        // Store current hour for next check
                        achievement.lastCheckInHour = Int16(hour)
                    }
                } else {
                    newProgress = previousProgress
                }
                
            case "Smart Saver":
                newProgress = min(Double(transactionCount) / 10.0, 1.0)
                
            case "Budget Master":
                newProgress = min(Double(daysUnderLimit) / 14.0, 1.0)
                
            case "Goal Getter":
                newProgress = goalReached ? 1.0 : 0.0
                
            default:
                continue
            }
            
            if newProgress != previousProgress {
                achievement.updateProgress(newProgress)
                hasChanges = true
            }
            
            if !wasUnlocked && achievement.isUnlocked {
                unlockedAchievements.append(achievement)
                unlockedInThisSession.insert(achievement.title)
            }
        }
        
        if hasChanges {
            try context.save()
        }
        
        return unlockedAchievements
    }
} 