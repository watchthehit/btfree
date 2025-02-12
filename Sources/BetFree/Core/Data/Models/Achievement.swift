import CoreData
import SwiftUI

@objc(Achievement)
public class Achievement: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var icon: String
    @NSManaged public var colorHex: String
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var progress: Double
    @NSManaged public var unlockDate: Date?
    
    public var color: Color {
        Color(hex: colorHex) ?? BFDesignSystem.Colors.primary
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
    
    static func createDefaultAchievements(context: NSManagedObjectContext) {
        let defaults = [
            (
                title: "First Step",
                description: "Complete your first day",
                icon: "figure.walk",
                color: BFDesignSystem.Colors.success
            ),
            (
                title: "Week Warrior",
                description: "Complete a 7-day streak",
                icon: "star.fill",
                color: BFDesignSystem.Colors.primary
            ),
            (
                title: "Money Master",
                description: "Save your first $100",
                icon: "dollarsign.circle.fill",
                color: BFDesignSystem.Colors.secondary
            ),
            (
                title: "Monthly Marvel",
                description: "Complete a 30-day streak",
                icon: "crown.fill",
                color: BFDesignSystem.Colors.accent
            )
        ]
        
        for achievementData in defaults {
            let achievement = Achievement(context: context)
            achievement.title = achievementData.title
            achievement.desc = achievementData.description
            achievement.icon = achievementData.icon
            achievement.colorHex = achievementData.color.toHex() ?? "#007AFF"
            achievement.isUnlocked = false
            achievement.progress = 0.0
        }
        
        try? context.save()
    }
} 