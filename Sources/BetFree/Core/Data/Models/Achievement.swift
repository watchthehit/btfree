import CoreData
import SwiftUI

@objc(BetFree_Achievement)
public final class Achievement: NSManagedObject, @unchecked Sendable {
    public static let entityName = "BetFree_Achievement"
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var icon: String
    @NSManaged public var colorHex: String
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var progress: Double
    @NSManaged public var unlockDate: Date?
    @NSManaged public var lastCheckInHour: Int16
    
    public var color: Color {
        switch colorHex {
        case "primary": return .blue
        case "secondary": return .green
        case "accent": return .pink
        case "success": return .green
        default: return .blue
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: entityName)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        title = ""
        desc = ""
        icon = ""
        colorHex = "primary"
        isUnlocked = false
        progress = 0.0
        unlockDate = nil
        lastCheckInHour = -1
    }
    
    public func updateProgress(_ newProgress: Double) {
        progress = min(max(newProgress, 0.0), 1.0)
        if progress >= 1.0 && !isUnlocked {
            isUnlocked = true
            unlockDate = Date()
        }
    }
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        if title.isEmpty { throw ValidationError.emptyTitle }
        if desc.isEmpty { throw ValidationError.emptyDescription }
        if icon.isEmpty { throw ValidationError.emptyIcon }
        if progress < 0.0 || progress > 1.0 { throw ValidationError.invalidProgressRange }
    }
    
    enum ValidationError: LocalizedError {
        case emptyTitle
        case emptyDescription
        case emptyIcon
        case invalidProgressRange
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle: return "Achievement title cannot be empty"
            case .emptyDescription: return "Achievement description cannot be empty"
            case .emptyIcon: return "Achievement icon cannot be empty"
            case .invalidProgressRange: return "Achievement progress must be between 0 and 1"
            }
        }
    }
    
    @MainActor
    static func createDefaultAchievements(context: NSManagedObjectContext) throws {
        let defaults = [
            // Streak Achievements
            (title: "First Step", description: "Complete your first day", icon: "figure.walk", color: "success"),
            (title: "Week Warrior", description: "Complete a 7-day streak", icon: "star.fill", color: "primary"),
            (title: "Monthly Marvel", description: "Complete a 30-day streak", icon: "crown.fill", color: "accent"),
            (title: "Quarterly Victor", description: "Complete a 90-day streak", icon: "medal.fill", color: "primary"),
            (title: "Annual Legend", description: "Complete a 365-day streak", icon: "crown.fill", color: "accent"),
            
            // Savings Achievements
            (title: "Money Master", description: "Save your first $100", icon: "dollarsign.circle.fill", color: "secondary"),
            (title: "Savings Champion", description: "Save $1,000 in total", icon: "trophy.fill", color: "success"),
            (title: "Wealth Builder", description: "Save $5,000 in total", icon: "bag.fill", color: "primary"),
            (title: "Fortune Maker", description: "Save $10,000 in total", icon: "sparkles", color: "accent"),
            
            // Check-in Achievements
            (title: "Early Bird", description: "Check in before 9 AM for 5 days", icon: "sunrise.fill", color: "success"),
            (title: "Night Owl", description: "Check in after 8 PM for 5 days", icon: "moon.stars.fill", color: "primary"),
            (title: "Consistency King", description: "Check in at the same time for 7 days", icon: "clock.fill", color: "accent"),
            
            // Transaction Achievements
            (title: "Smart Saver", description: "Add 10 savings transactions", icon: "plus.circle.fill", color: "success"),
            (title: "Budget Master", description: "Stay under daily limit for 14 days", icon: "chart.line.downtrend.xyaxis", color: "primary"),
            (title: "Goal Getter", description: "Reach your savings goal", icon: "target", color: "accent")
        ]
        
        let request = NSFetchRequest<Achievement>(entityName: Achievement.entityName)
        request.predicate = NSPredicate(format: "title IN %@", defaults.map { $0.title })
        let existing = try context.fetch(request)
        let existingTitles = Set(existing.map { $0.title })
        
        for achievementData in defaults where !existingTitles.contains(achievementData.title) {
            let achievement = Achievement(context: context)
            achievement.id = UUID()
            achievement.title = achievementData.title
            achievement.desc = achievementData.description
            achievement.icon = achievementData.icon
            achievement.colorHex = achievementData.color
            achievement.isUnlocked = false
            achievement.progress = 0.0
            achievement.unlockDate = nil
            achievement.lastCheckInHour = -1
        }
        
        try context.save()
    }
    
    #if DEBUG
    @MainActor
    static var samples: [Achievement] {
        let model = CoreDataModel.createModel()
        let container = NSPersistentContainer(name: "BetFreeModel", managedObjectModel: model)
        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        let context = container.viewContext
        
        let samples = [
            createSample(title: "First Step", description: "Complete your first day", icon: "figure.walk", color: "success", context: context),
            createSample(title: "Week Warrior", description: "Complete a 7-day streak", icon: "star.fill", color: "primary", context: context),
            createSample(title: "Money Master", description: "Save your first $100", icon: "dollarsign.circle.fill", color: "secondary", context: context)
        ]
        
        try? context.save()
        return samples
    }
    
    @MainActor
    private static func createSample(title: String, description: String, icon: String, color: String, context: NSManagedObjectContext) -> Achievement {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = title
        achievement.desc = description
        achievement.icon = icon
        achievement.colorHex = color
        achievement.isUnlocked = false
        achievement.progress = 0.0
        achievement.unlockDate = nil
        achievement.lastCheckInHour = -1
        return achievement
    }
    #endif
}

extension Achievement: Identifiable {} 