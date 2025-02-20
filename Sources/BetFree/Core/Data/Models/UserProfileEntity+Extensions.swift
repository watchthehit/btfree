import Foundation
import CoreData
import BetFreeModels

extension UserProfileEntity {
    var userProfile: UserProfile {
        UserProfile(
            name: name,
            email: email,
            streak: Int(streak),
            totalSavings: totalSavings,
            dailyLimit: dailyLimit,
            lastCheckIn: lastCheckIn
        )
    }
    
    static func create(from profile: UserProfile, in context: NSManagedObjectContext) -> UserProfileEntity {
        let entity = UserProfileEntity(context: context)
        entity.name = profile.name
        entity.email = profile.email
        entity.streak = Int32(profile.streak)
        entity.totalSavings = profile.totalSavings
        entity.dailyLimit = profile.dailyLimit
        entity.lastCheckIn = profile.lastCheckIn
        return entity
    }
    
    func update(from profile: UserProfile) {
        name = profile.name
        email = profile.email
        streak = Int32(profile.streak)
        totalSavings = profile.totalSavings
        dailyLimit = profile.dailyLimit
        lastCheckIn = profile.lastCheckIn
    }
} 