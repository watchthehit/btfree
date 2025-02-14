import Foundation
import CoreData

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var username: String
    @NSManaged public var streak: Int32
    @NSManaged public var savings: Double
    @NSManaged public var totalSavings: Double
    @NSManaged public var dailyLimit: Double
    @NSManaged public var lastLoginDate: Date
    @NSManaged public var lastCheckIn: Date?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        lastLoginDate = Date()
        lastCheckIn = nil
        streak = 0
        savings = 0
        totalSavings = 0
        dailyLimit = 0
        name = ""
        email = ""
        username = ""
    }
}

extension UserProfileEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        return NSFetchRequest<UserProfileEntity>(entityName: "UserProfile")
    }
}

extension UserProfileEntity : Identifiable {} 