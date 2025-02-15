import CoreData
import Foundation

@MainActor
public class MockCDManager: BetFreeDataManager {
    public static let shared = MockCDManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        // Create an in-memory model
        let model = NSManagedObjectModel()
        
        // User Profile Entity
        let userEntity = NSEntityDescription()
        userEntity.name = "BetFree_UserProfile"
        userEntity.managedObjectClassName = "BetFree.UserProfileEntity"
        
        let userIdAttribute = NSAttributeDescription()
        userIdAttribute.name = "id"
        userIdAttribute.attributeType = .UUIDAttributeType
        userIdAttribute.isOptional = false
        userIdAttribute.defaultValue = UUID()
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = false
        nameAttribute.defaultValue = ""
        
        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.attributeType = .stringAttributeType
        emailAttribute.isOptional = true
        
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
        
        let totalSavingsAttribute = NSAttributeDescription()
        totalSavingsAttribute.name = "totalSavings"
        totalSavingsAttribute.attributeType = .doubleAttributeType
        totalSavingsAttribute.isOptional = false
        totalSavingsAttribute.defaultValue = 0.0
        
        userEntity.properties = [
            userIdAttribute,
            nameAttribute,
            emailAttribute,
            dailyLimitAttribute,
            streakAttribute,
            lastCheckInAttribute,
            totalSavingsAttribute
        ]
        
        // Transaction Entity
        let transactionEntity = NSEntityDescription()
        transactionEntity.name = "TransactionEntity"
        transactionEntity.managedObjectClassName = "BetFree.TransactionEntity"
        
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
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.attributeType = .stringAttributeType
        categoryAttribute.isOptional = true
        
        transactionEntity.properties = [
            transactionIdAttribute,
            amountAttribute,
            dateAttribute,
            noteAttribute,
            categoryAttribute
        ]
        
        model.entities = [userEntity, transactionEntity]
        
        // Create container with in-memory store
        let container = NSPersistentContainer(name: "BetFreeTestModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func getCurrentUser() -> UserProfileEntity? {
        let request = NSFetchRequest<UserProfileEntity>(entityName: "BetFree_UserProfile")
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
                // Increment streak for consecutive days
                user.streak += 1
            } else if daysSinceLastCheckIn > 1 {
                // Reset streak for missed days
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
        user.totalSavings = amount
        try context.save()
    }
    
    public func addTransaction(amount: Double, note: String? = nil) throws {
        let transaction = TransactionEntity(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = Date()
        transaction.note = note
        transaction.category = amount < 0 ? "expense" : "saving"
        
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
    
    public func save() throws {
        try context.save()
    }
    
    public func reset() {
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap { $0.name }.forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(deleteRequest)
        }
        try? context.save()
    }
}