import CoreData
import Foundation
@testable import BetFree

@MainActor
public class MockCoreDataManager: DataManager {
    public static var shared = MockCoreDataManager()
    private static var sharedModel: NSManagedObjectModel?
    
    private let container: NSPersistentContainer
    
    public init() {
        print("Initializing MockCoreDataManager...")
        
        // Create or reuse model
        let model = Self.sharedModel ?? {
            let model = NSManagedObjectModel()
            
            // User Profile Entity
            let userEntity = NSEntityDescription()
            userEntity.name = "BetFree_UserProfile"
            userEntity.managedObjectClassName = "BetFree.UserProfile"
            
            let userIdAttribute = NSAttributeDescription()
            userIdAttribute.name = "id"
            userIdAttribute.attributeType = .UUIDAttributeType
            userIdAttribute.isOptional = false
            userIdAttribute.defaultValue = UUID()
            
            let nameAttribute = NSAttributeDescription()
            nameAttribute.name = "name"
            nameAttribute.attributeType = .stringAttributeType
            nameAttribute.isOptional = true
            nameAttribute.defaultValue = ""
            
            let emailAttribute = NSAttributeDescription()
            emailAttribute.name = "email"
            emailAttribute.attributeType = .stringAttributeType
            emailAttribute.isOptional = true
            emailAttribute.defaultValue = ""
            
            let usernameAttribute = NSAttributeDescription()
            usernameAttribute.name = "username"
            usernameAttribute.attributeType = .stringAttributeType
            usernameAttribute.isOptional = false
            usernameAttribute.defaultValue = "User"
            
            let dailyLimitAttribute = NSAttributeDescription()
            dailyLimitAttribute.name = "dailyLimit"
            dailyLimitAttribute.attributeType = .doubleAttributeType
            dailyLimitAttribute.isOptional = false
            dailyLimitAttribute.defaultValue = 0.0
            
            let streakAttribute = NSAttributeDescription()
            streakAttribute.name = "streak"
            streakAttribute.attributeType = .integer32AttributeType
            streakAttribute.isOptional = false
            streakAttribute.defaultValue = 0
            
            let lastCheckInAttribute = NSAttributeDescription()
            lastCheckInAttribute.name = "lastCheckIn"
            lastCheckInAttribute.attributeType = .dateAttributeType
            lastCheckInAttribute.isOptional = true
            
            let lastLoginDateAttribute = NSAttributeDescription()
            lastLoginDateAttribute.name = "lastLoginDate"
            lastLoginDateAttribute.attributeType = .dateAttributeType
            lastLoginDateAttribute.isOptional = false
            lastLoginDateAttribute.defaultValue = Date()
            
            let savingsAttribute = NSAttributeDescription()
            savingsAttribute.name = "savings"
            savingsAttribute.attributeType = .doubleAttributeType
            savingsAttribute.isOptional = false
            savingsAttribute.defaultValue = 0.0
            
            let totalSavingsAttribute = NSAttributeDescription()
            totalSavingsAttribute.name = "totalSavings"
            totalSavingsAttribute.attributeType = .doubleAttributeType
            totalSavingsAttribute.isOptional = false
            totalSavingsAttribute.defaultValue = 0.0
            
            userEntity.properties = [
                userIdAttribute,
                nameAttribute,
                emailAttribute,
                usernameAttribute,
                dailyLimitAttribute,
                streakAttribute,
                lastCheckInAttribute,
                lastLoginDateAttribute,
                savingsAttribute,
                totalSavingsAttribute
            ]
            
            // Transaction Entity
            let transactionEntity = NSEntityDescription()
            transactionEntity.name = "Transaction"
            transactionEntity.managedObjectClassName = "BetFree.Transaction"
            
            let transactionIdAttribute = NSAttributeDescription()
            transactionIdAttribute.name = "id"
            transactionIdAttribute.attributeType = .UUIDAttributeType
            transactionIdAttribute.isOptional = false
            transactionIdAttribute.defaultValue = UUID()
            
            let amountAttribute = NSAttributeDescription()
            amountAttribute.name = "amount"
            amountAttribute.attributeType = .doubleAttributeType
            amountAttribute.isOptional = false
            amountAttribute.defaultValue = 0.0
            
            let dateAttribute = NSAttributeDescription()
            dateAttribute.name = "date"
            dateAttribute.attributeType = .dateAttributeType
            dateAttribute.isOptional = false
            dateAttribute.defaultValue = Date()
            
            let noteAttribute = NSAttributeDescription()
            noteAttribute.name = "note"
            noteAttribute.attributeType = .stringAttributeType
            noteAttribute.isOptional = true
            noteAttribute.defaultValue = ""
            
            let categoryAttribute = NSAttributeDescription()
            categoryAttribute.name = "category"
            categoryAttribute.attributeType = .stringAttributeType
            categoryAttribute.isOptional = true
            categoryAttribute.defaultValue = ""
            
            transactionEntity.properties = [
                transactionIdAttribute,
                amountAttribute,
                dateAttribute,
                noteAttribute,
                categoryAttribute
            ]
            
            // Add entities to model
            model.entities = [userEntity, transactionEntity]
            
            print("Created model with entities: \(model.entities.map { $0.name ?? "unnamed" })")
            
            // Store model for reuse
            Self.sharedModel = model
            
            return model
        }()
        
        // Create container with in-memory store
        let container = NSPersistentContainer(name: "BetFreeTestModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        // Load stores synchronously for testing
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            print("Successfully loaded persistent store")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        self.container = container
    }
    
    public var context: NSManagedObjectContext {
        container.viewContext
    }
    
    public func getCurrentUser() -> UserProfile? {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }
    
    public func createOrUpdateUser(name: String?, email: String?, dailyLimit: Double) throws {
        let user: UserProfile
        if let existingUser = getCurrentUser() {
            user = existingUser
        } else {
            user = UserProfile(context: context)
            user.id = UUID()
            user.streak = 0
            user.totalSavings = 0
            user.savings = 0
            user.lastLoginDate = Date()
            user.username = name ?? "User"
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
    
    public func addTransaction(amount: Double, note: String?) throws {
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
    
    public func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    public static func resetShared() {
        print("Starting shared instance reset...")
        
        // Reset the context of the current shared instance
        shared.reset()
        
        // Reset the shared model
        sharedModel = nil
        
        // Create new instance
        print("Creating new instance...")
        let newInstance = MockCoreDataManager()
        
        // Assign the new instance
        print("Assigning new instance...")
        shared = newInstance
        
        print("Successfully completed shared instance reset")
    }
    
    public func reset() {
        print("Resetting MockCoreDataManager data...")
        
        // Reset the context
        context.reset()
        
        // Perform batch delete for all entities
        let coordinator = container.persistentStoreCoordinator
        
        let entities = container.managedObjectModel.entities
        entities.compactMap { $0.name }.forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try coordinator.execute(deleteRequest, with: context)
            } catch {
                print("Error resetting \(entityName): \(error)")
            }
        }
        
        // Save changes
        do {
            try context.save()
        } catch {
            print("Error saving after reset: \(error)")
        }
        
        print("Reset complete")
    }
    
    deinit {
        print("MockCoreDataManager deinit")
    }
} 