import Foundation
import CoreData

@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var username: String
    @NSManaged public var streak: Int32
    @NSManaged public var savings: Double
    @NSManaged public var totalSavings: Double
    @NSManaged public var dailyLimit: Double
    @NSManaged public var lastLoginDate: Date
    @NSManaged public var lastCheckIn: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        lastLoginDate = Date()
        lastCheckIn = Date()
        streak = 0
        savings = 0
        totalSavings = 0
        dailyLimit = 0
        name = ""
        email = ""
        username = ""
    }
}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }
} 