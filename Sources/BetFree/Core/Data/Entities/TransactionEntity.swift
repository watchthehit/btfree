import Foundation
import CoreData

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var note: String?
}

extension TransactionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }
} 