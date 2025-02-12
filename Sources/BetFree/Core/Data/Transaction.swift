import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var category: String
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        date = Date()
        category = "Expense"
    }
}

extension Transaction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }
} 