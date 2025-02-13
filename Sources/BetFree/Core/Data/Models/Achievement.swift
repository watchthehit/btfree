import CoreData
import SwiftUI

@objc(Achievement)
public final class Achievement: NSManagedObject, @unchecked Sendable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var icon: String
    @NSManaged public var colorHex: String
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var progress: Double
    @NSManaged public var unlockDate: Date?
    
    public var color: Color {
        Color(hex: colorHex)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        isUnlocked = false
        progress = 0.0
        colorHex = "#007AFF" // Default color
    }
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        if title.isEmpty { throw ValidationError.emptyTitle }
        if desc.isEmpty { throw ValidationError.emptyDescription }
        if icon.isEmpty { throw ValidationError.emptyIcon }
    }
    
    enum ValidationError: LocalizedError {
        case emptyTitle
        case emptyDescription
        case emptyIcon
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle: return "Achievement title cannot be empty"
            case .emptyDescription: return "Achievement description cannot be empty"
            case .emptyIcon: return "Achievement icon cannot be empty"
            }
        }
    }
    
    static func createDefaultAchievements(context: NSManagedObjectContext) throws {
        let defaults = [
            // Streak Achievements
            (title: "First Step", description: "Complete your first day", icon: "figure.walk", color: BFDesignSystem.Colors.success),
            (title: "Week Warrior", description: "Complete a 7-day streak", icon: "star.fill", color: BFDesignSystem.Colors.primary),
            (title: "Monthly Marvel", description: "Complete a 30-day streak", icon: "crown.fill", color: BFDesignSystem.Colors.accent),
            (title: "Quarterly Victor", description: "Complete a 90-day streak", icon: "medal.fill", color: BFDesignSystem.Colors.primary),
            (title: "Annual Legend", description: "Complete a 365-day streak", icon: "crown.fill", color: BFDesignSystem.Colors.accent),
            
            // Savings Achievements
            (title: "Money Master", description: "Save your first $100", icon: "dollarsign.circle.fill", color: BFDesignSystem.Colors.secondary),
            (title: "Savings Champion", description: "Save $1,000 in total", icon: "trophy.fill", color: BFDesignSystem.Colors.success),
            (title: "Wealth Builder", description: "Save $5,000 in total", icon: "bag.fill", color: BFDesignSystem.Colors.primary),
            (title: "Fortune Maker", description: "Save $10,000 in total", icon: "sparkles", color: BFDesignSystem.Colors.accent),
            
            // Check-in Achievements
            (title: "Early Bird", description: "Check in before 9 AM for 5 days", icon: "sunrise.fill", color: BFDesignSystem.Colors.success),
            (title: "Night Owl", description: "Check in after 8 PM for 5 days", icon: "moon.stars.fill", color: BFDesignSystem.Colors.primary),
            (title: "Consistency King", description: "Check in at the same time for 7 days", icon: "clock.fill", color: BFDesignSystem.Colors.accent),
            
            // Transaction Achievements
            (title: "Smart Saver", description: "Add 10 savings transactions", icon: "plus.circle.fill", color: BFDesignSystem.Colors.success),
            (title: "Budget Master", description: "Stay under daily limit for 14 days", icon: "chart.line.downtrend.xyaxis", color: BFDesignSystem.Colors.primary),
            (title: "Goal Getter", description: "Reach your savings goal", icon: "target", color: BFDesignSystem.Colors.accent)
        ]
        // Check for existing achievements
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.predicate = NSPredicate(format: "title IN %@", defaults.map { $0.title })
        let existing = try context.fetch(request)
        let existingTitles = Set(existing.map { $0.title })
        
        for achievementData in defaults where !existingTitles.contains(achievementData.title) {
            let achievement = Achievement(context: context)
            achievement.title = achievementData.title
            achievement.desc = achievementData.description
            achievement.icon = achievementData.icon
            achievement.colorHex = achievementData.color.toHex() ?? "#007AFF"
            achievement.isUnlocked = false
            achievement.progress = 0.0
        }
        
        try context.save()
    }
    
    #if DEBUG
    static var samples: [Achievement] {
        let container = NSPersistentContainer(name: "BetFreeModel")
        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        let context = container.viewContext
        
        let samples = [
            createSample(title: "First Step", description: "Complete your first day", icon: "figure.walk", color: BFDesignSystem.Colors.success, context: context),
            createSample(title: "Week Warrior", description: "Complete a 7-day streak", icon: "star.fill", color: BFDesignSystem.Colors.primary, context: context),
            createSample(title: "Money Master", description: "Save your first $100", icon: "dollarsign.circle.fill", color: BFDesignSystem.Colors.secondary, context: context)
        ]
        
        try? context.save()
        return samples
    }
    
    private static func createSample(title: String, description: String, icon: String, color: Color, context: NSManagedObjectContext) -> Achievement {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = title
        achievement.desc = description
        achievement.icon = icon
        achievement.colorHex = color.toHex() ?? "#007AFF"
        achievement.isUnlocked = Bool.random()
        achievement.progress = Double.random(in: 0...1)
        return achievement
    }
    #endif
}

extension Achievement {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }
}

extension Achievement: Identifiable {} 