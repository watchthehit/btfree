import CoreData

public enum BFPersistenceError: Error {
    case failedToLoadStore(Error)
    case modelCreationFailed
}

@MainActor
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
    private var isLoaded = false
    private var loadTask: Task<Void, Error>?
    
    public init(inMemory: Bool = false) {
        print("🔄 Initializing BFPersistenceController")
        
        // Use the programmatic model
        let model = CoreDataModel.shared.createModel()
        print("✅ Core Data model created")
        
        container = NSPersistentContainer(name: "BetFree", managedObjectModel: model)
        
        if inMemory {
            print("📱 Using in-memory store")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            print("💾 Using persistent store")
            if let storeURL = container.persistentStoreDescriptions.first?.url {
                print("📍 Store URL: \(storeURL)")
            }
        }
        
        // Configure automatic merging
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Start loading stores
        loadTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.loadPersistentStores()
                print("✅ Core Data configuration complete")
            } catch {
                print("❌ Fatal error loading Core Data store: \(error.localizedDescription)")
                print("Stack trace: \(Thread.callStackSymbols.joined(separator: "\n"))")
                throw error
            }
        }
    }
    
    private func loadPersistentStores() async throws {
        print("🔄 Starting to load persistent stores")
        return try await withCheckedThrowingContinuation { continuation in
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("❌ Core Data failed to load: \(error.localizedDescription)")
                    print("📝 Store description: \(description)")
                    continuation.resume(throwing: BFPersistenceError.failedToLoadStore(error))
                } else {
                    print("✅ Core Data store loaded successfully")
                    self.isLoaded = true
                    continuation.resume()
                }
            }
        }
    }
    
    public func waitForLoad() async throws {
        if !isLoaded {
            print("⏳ Waiting for Core Data to load...")
            try await loadTask?.value
        }
    }
    
    public func save() {
        let context = container.viewContext
        
        guard isLoaded else {
            print("⚠️ Warning: Attempting to save before Core Data is fully loaded")
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data context saved successfully")
            } catch {
                print("❌ Error saving Core Data context: \(error)")
            }
        }
    }
    
    public func reset() async throws {
        print("🔄 Starting Core Data reset")
        let coordinator = container.persistentStoreCoordinator
        
        // Remove all existing stores
        try coordinator.persistentStores.forEach { store in
            print("🗑️ Removing store at: \(store.url?.absoluteString ?? "unknown")")
            try coordinator.remove(store)
        }
        
        // Reset the loaded state
        isLoaded = false
        
        // Load stores again
        try await loadPersistentStores()
        
        // Reset the view context
        container.viewContext.reset()
        print("✅ Core Data reset complete")
    }
}

