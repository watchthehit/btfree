import CoreData
import Foundation

@MainActor
public final class AchievementService {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetchAchievements() async throws -> [Achievement] {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<Achievement>(entityName: "Achievement")
                    request.sortDescriptors = [NSSortDescriptor(keyPath: \Achievement.title, ascending: true)]
                    let achievements = try self.context.fetch(request)
                    continuation.resume(returning: achievements)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func updateProgress(forAchievement id: UUID, progress: Double) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<Achievement>(entityName: "Achievement")
                    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    
                    guard let achievement = try self.context.fetch(request).first else {
                        continuation.resume()
                        return
                    }
                    
                    achievement.progress = min(max(progress, 0.0), 1.0)
                    
                    if progress >= 1.0 && !achievement.isUnlocked {
                        achievement.isUnlocked = true
                        achievement.unlockDate = Date()
                    }
                    
                    try self.context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func checkAndUpdateAchievements(
        streak: Int32,
        savings: Double,
        checkInTime: Date? = nil,
        transactionCount: Int = 0,
        daysUnderLimit: Int = 0,
        goalReached: Bool = false
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<Achievement>(entityName: "Achievement")
                    let achievements = try self.context.fetch(request)
                    var hasChanges = false
                    
                    for achievement in achievements {
                        var progress: Double = 0.0
                        
                        switch achievement.title {
                        // Streak Achievements
                        case "First Step":
                            progress = streak > 0 ? 1.0 : 0.0
                        case "Week Warrior":
                            progress = min(Double(streak) / 7.0, 1.0)
                        case "Monthly Marvel":
                            progress = min(Double(streak) / 30.0, 1.0)
                        case "Quarterly Victor":
                            progress = min(Double(streak) / 90.0, 1.0)
                        case "Annual Legend":
                            progress = min(Double(streak) / 365.0, 1.0)
                            
                        // Savings Achievements
                        case "Money Master":
                            progress = min(savings / 100.0, 1.0)
                        case "Savings Champion":
                            progress = min(savings / 1000.0, 1.0)
                        case "Wealth Builder":
                            progress = min(savings / 5000.0, 1.0)
                        case "Fortune Maker":
                            progress = min(savings / 10000.0, 1.0)
                            
                        // Check-in Achievements
                        case "Early Bird":
                            if let time = checkInTime {
                                let hour = Calendar.current.component(.hour, from: time)
                                progress = hour < 9 ? min(Double(streak) / 5.0, 1.0) : 0.0
                            }
                        case "Night Owl":
                            if let time = checkInTime {
                                let hour = Calendar.current.component(.hour, from: time)
                                progress = hour >= 20 ? min(Double(streak) / 5.0, 1.0) : 0.0
                            }
                        case "Consistency King":
                            if checkInTime != nil {
                                progress = min(Double(streak) / 7.0, 1.0)
                            }
                            
                        // Transaction Achievements
                        case "Smart Saver":
                            progress = min(Double(transactionCount) / 10.0, 1.0)
                        case "Budget Master":
                            progress = min(Double(daysUnderLimit) / 14.0, 1.0)
                        case "Goal Getter":
                            progress = goalReached ? 1.0 : 0.0
                            
                        default:
                            continue
                        }
                        
                        let newProgress = min(max(progress, 0.0), 1.0)
                        if achievement.progress != newProgress {
                            achievement.progress = newProgress
                            hasChanges = true
                        }
                        
                        if progress >= 1.0 && !achievement.isUnlocked {
                            achievement.isUnlocked = true
                            achievement.unlockDate = Date()
                            hasChanges = true
                        }
                    }
                    
                    if hasChanges {
                        try self.context.save()
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func initializeDefaultAchievementsIfNeeded() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let count = try self.context.count(for: NSFetchRequest<Achievement>(entityName: "Achievement"))
                    if count == 0 {
                        try Achievement.createDefaultAchievements(context: self.context)
                        try self.context.save()
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
} 