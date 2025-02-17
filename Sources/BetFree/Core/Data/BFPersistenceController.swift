import CoreData

public enum BFPersistenceError: Error {
    case failedToLoadStore(Error)
}

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
    private var loadError: Error?
    
    public init(inMemory: Bool = false) {
        print("Initializing BFPersistenceController")
        
        // Use the model from the main bundle
        guard let modelURL = Bundle.module.url(forResource: "BetFreeModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }
        
        container = NSPersistentContainer(name: "BetFreeModel", managedObjectModel: model)
        
        if inMemory {
            print("Using in-memory store")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            print("Using persistent store")
            if let storeURL = container.persistentStoreDescriptions.first?.url {
                print("Store URL: \(storeURL)")
            }
        }
        
        var loadError: Error?
        let group = DispatchGroup()
        group.enter()
        
        container.loadPersistentStores { description, error in
            defer { group.leave() }
            if let error = error {
                print(" Core Data failed to load: \(error.localizedDescription)")
                print("Store description: \(description)")
                loadError = error
            } else {
                print(" Core Data store loaded successfully")
            }
        }
        
        group.wait()
        
        if let error = loadError {
            print("Fatal error: Failed to load Core Data store")
            fatalError(error.localizedDescription)
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        print("Core Data configuration complete")
    }
    
    public func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print(" Core Data context saved successfully")
            } catch {
                print(" Error saving Core Data context: \(error)")
            }
        }
    }
}
