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
        let container = NSPersistentContainer(name: "BetFree", managedObjectModel: CoreDataModel.createModel())
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to load persistent stores: \(error)")
            }
        }
        
        // Configure the container
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - User Profile Methods
    
    public func getCurrentUser() -> UserProfileEntity? {
        let request = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
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
            let entity = NSEntityDescription.entity(forEntityName: "UserProfileEntity", in: context)!
            user = UserProfileEntity(entity: entity, insertInto: context)
            user.id = UUID()
            user.streak = 0
            user.totalSavings = 0
        }
        
        user.name = name ?? ""
        user.email = email
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
    
    // MARK: - Transaction Methods
    
    public func addTransaction(amount: Double, note: String? = nil) throws {
        let transaction = TransactionEntity(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = Date()
        transaction.category = amount < 0 ? "expense" : "saving"
        transaction.note = note
        
        try updateTotalSavings(amount: amount)
        try context.save()
    }
    
    public func getTodaysTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Transaction(
                    id: entity.id,
                    amount: entity.amount,
                    date: entity.date,
                    category: entity.category,
                    note: entity.note
                )
            }
        } catch {
            print("Error fetching today's transactions: \(error)")
            return []
        }
    }
    
    public func getTotalSpentToday() -> Double {
        getTodaysTransactions()
            .filter { $0.amount < 0 }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    // MARK: - Utility Methods
    
    public func save() throws {
        try context.save()
    }
    
    public func reset() {
        // Delete all transactions
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfileEntity")
        
        do {
            // Delete transactions
            if let transactions = try context.fetch(transactionFetch) as? [TransactionEntity] {
                transactions.forEach { context.delete($0) }
            }
            
            // Delete user profiles
            if let users = try context.fetch(userFetch) as? [UserProfileEntity] {
                users.forEach { context.delete($0) }
            }
            
            try context.save()
        } catch {
            print("Error resetting Core Data: \(error)")
        }
    }
}