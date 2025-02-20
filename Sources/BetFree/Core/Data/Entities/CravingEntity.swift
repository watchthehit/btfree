import Foundation
import CoreData

@objc(CravingEntity)
public class CravingEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var trigger: String
    @NSManaged public var intensity: Int16
    @NSManaged public var date: Date
    @NSManaged public var location: String?
    @NSManaged public var note: String?
    @NSManaged public var duration: Int32
}

extension CravingEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CravingEntity> {
        return NSFetchRequest<CravingEntity>(entityName: "CravingEntity")
    }
} 