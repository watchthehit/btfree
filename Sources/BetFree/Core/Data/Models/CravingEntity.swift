import CoreData

@objc(CravingEntity)
public class CravingEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var intensity: Int32
    @NSManaged public var triggers: String?
    @NSManaged public var strategies: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var duration: Int32
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        timestamp = Date()
    }
}

extension CravingEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CravingEntity> {
        return NSFetchRequest<CravingEntity>(entityName: "CravingEntity")
    }
} 