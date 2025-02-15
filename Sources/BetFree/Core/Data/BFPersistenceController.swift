import CoreData

public class BFPersistenceController {
    public static let shared = BFPersistenceController()
    
    public static var preview: BFPersistenceController = {
        let controller = BFPersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        let user = UserProfileEntity(context: context)
        user.name = "Preview User"
        user.email = "preview@example.com"
        user.streak = 7
        user.totalSavings = 1234.56
        user.dailyLimit = 50.0
        user.lastCheckIn = Date()
        
        let transaction = TransactionEntity(context: context)
        transaction.amount = 25.0
        transaction.category = "food"
        transaction.note = "Lunch"
        
        try? context.save()
        return controller
    }()
    
    public let container: NSPersistentContainer
    
    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BetFree")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    public func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
