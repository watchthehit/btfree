import CoreData
import Foundation

public class AchievementService {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetchAchievements() throws -> [Achievement] {
        let request = NSFetchRequest<Achievement>(entityName: "Achievement")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Achievement.title, ascending: true)]
        return try context.fetch(request)
    }
    
    public func updateProgress(forAchievement id: UUID, progress: Double) throws {
        let request = NSFetchRequest<Achievement>(entityName: "Achievement")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let achievement = try context.fetch(request).first {
            achievement.progress = min(max(progress, 0.0), 1.0)
            
            if progress >= 1.0 && !achievement.isUnlocked {
                achievement.isUnlocked = true
                achievement.unlockDate = Date()
            }
            
            try context.save()
        }
    }
    
    public func checkAndUpdateAchievements(streak: Int32, savings: Double) throws {
        let achievements = try fetchAchievements()
        
        for achievement in achievements {
            var progress: Double = 0.0
            
            switch achievement.title {
            case "First Step":
                progress = streak > 0 ? 1.0 : 0.0
            case "Week Warrior":
                progress = min(Double(streak) / 7.0, 1.0)
            case "Money Master":
                progress = min(savings / 100.0, 1.0)
            case "Monthly Marvel":
                progress = min(Double(streak) / 30.0, 1.0)
            default:
                continue
            }
            
            try updateProgress(forAchievement: achievement.id, progress: progress)
        }
    }
    
    public func initializeDefaultAchievementsIfNeeded() throws {
        let count = try context.count(for: NSFetchRequest<Achievement>(entityName: "Achievement"))
        if count == 0 {
            Achievement.createDefaultAchievements(context: context)
        }
    }
} 