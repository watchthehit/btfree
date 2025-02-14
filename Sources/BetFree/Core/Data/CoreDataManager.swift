import CoreData
import Foundation

@MainActor
public final class CoreDataManager: BetFreeDataManager {
    public static var shared: BetFreeDataManager = DataManagerFactory.createDataManager()
    
    public init() {
        // Load the model immediately to catch any initialization errors
        _ = persistentContainer
    }
    
    public lazy var persistentContainer: NSPersistentContainer = {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // Running in tests, use in-memory store
            return MockCDManager.shared.persistentContainer
        }
        #endif
        
        // Create container with in-memory store
        let container = NSPersistentContainer(name: "BetFreeModel", managedObjectModel: CoreDataModel.createModel())
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        // Configure the container
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Create a local instance of the merge policy to avoid shared state
        let mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        container.viewContext.mergePolicy = mergePolicy
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Transaction Methods
    
    public func addTransaction(amount: Double, note: String? = nil) throws {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = Date()
        transaction.note = note
        transaction.category = amount < 0 ? "Expense" : "Savings"
        
        try context.save()
    }
    
    public func getTodaysTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching today's transactions: \(error)")
            return []
        }
    }
    
    public func getTotalSpentToday() -> Double {
        getTodaysTransactions().reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - User Profile Methods
    
    public func getCurrentUser() -> UserProfileEntity? {
        let request: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }
    
    public func createOrUpdateUser(name: String?, email: String?, dailyLimit: Double) throws {
        let user: UserProfileEntity
        if let existingUser = getCurrentUser() {
            user = existingUser
        } else {
            user = UserProfileEntity(context: context)
        }
        
        user.name = name ?? ""
        user.email = email ?? ""
        user.dailyLimit = dailyLimit
        
        try context.save()
    }
    
    public func updateUserStreak() throws {
        guard let user = getCurrentUser() else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        if let lastCheckIn = user.lastCheckIn {
            let daysSinceLastCheckIn = calendar.dateComponents([.day], from: lastCheckIn, to: now).day ?? 0
            
            if daysSinceLastCheckIn == 1 {
                // Consecutive day
                user.streak += 1
            } else if daysSinceLastCheckIn > 1 {
                // Streak broken
                user.streak = 1
            }
        } else {
            // First check-in
            user.streak = 1
        }
        
        user.lastCheckIn = now
        try context.save()
    }
    
    public func updateTotalSavings(amount: Double) throws {
        guard let user = getCurrentUser() else { return }
        user.totalSavings += amount
        try context.save()
    }
    
    // MARK: - Helper Methods
    
    public func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func reset() {
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap { $0.name }.forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            } catch {
                print("Error resetting data: \(error)")
            }
        }
    }
} 