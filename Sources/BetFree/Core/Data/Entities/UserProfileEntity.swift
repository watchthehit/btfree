import Foundation
import CoreData

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {
    @NSManaged public var idString: String
    @NSManaged public var name: String
    @NSManaged public var email: String?
    @NSManaged public var streak: Int32
    @NSManaged public var totalSavings: Double
    @NSManaged public var dailyLimit: Double
    @NSManaged public var lastCheckIn: Date?
    @NSManaged public var transactions: Set<TransactionEntity>?
    @NSManaged public var cravings: Set<CravingEntity>?
}

extension UserProfileEntity {
    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionEntity)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionEntity)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)
    
    @objc(addCravingsObject:)
    @NSManaged public func addToCravings(_ value: CravingEntity)

    @objc(removeCravingsObject:)
    @NSManaged public func removeFromCravings(_ value: CravingEntity)

    @objc(addCravings:)
    @NSManaged public func addToCravings(_ values: NSSet)

    @objc(removeCravings:)
    @NSManaged public func removeFromCravings(_ values: NSSet)

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
    }
    
    public var transactionsArray: [TransactionEntity] {
        let set = transactions ?? []
        return Array(set)
    }
    
    public var cravingsArray: [CravingEntity] {
        let set = cravings ?? []
        return Array(set)
    }
} 