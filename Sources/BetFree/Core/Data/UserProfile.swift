import Foundation
import CoreData

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String?
    @NSManaged public var streak: Int32
    @NSManaged public var totalSavings: Double
    @NSManaged public var dailyLimit: Double
    @NSManaged public var lastCheckIn: Date?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        streak = 0
        totalSavings = 0
        dailyLimit = 0
        name = ""
    }
}

extension UserProfileEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        return NSFetchRequest<UserProfileEntity>(entityName: "BetFree_UserProfile")
    }
}

extension UserProfileEntity : Identifiable {}