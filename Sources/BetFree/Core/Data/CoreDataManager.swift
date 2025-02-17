import CoreData
import Foundation
import BetFreeModels

@MainActor
public final class CoreDataManager: BetFreeDataManager {
    public static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        // Use the model from the module bundle
        guard let modelURL = Bundle.module.url(forResource: "BetFreeModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }
        
        let container = NSPersistentContainer(name: "BetFreeModel", managedObjectModel: model)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to load persistent stores: \(error)")
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init() {}
    
    private func getCurrentUserEntity() -> UserProfileEntity? {
        let request = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    public func getCurrentUser() -> UserProfile? {
        guard let entity = getCurrentUserEntity() else { return nil }
        return UserProfile(
            name: entity.name ?? "",
            email: entity.email,
            streak: Int(entity.streak),
            totalSavings: entity.totalSavings,
            dailyLimit: entity.dailyLimit,
            lastCheckIn: entity.lastCheckIn
        )
    }
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        if let existingUser = getCurrentUserEntity() {
            existingUser.name = name
            existingUser.email = email
            existingUser.dailyLimit = dailyLimit
            existingUser.idString = name
        } else {
            let user = UserProfileEntity(context: context)
            user.idString = name
            user.name = name
            user.email = email
            user.dailyLimit = dailyLimit
            user.streak = 0
            user.totalSavings = 0
            user.lastCheckIn = Date()
        }
        try context.save()
    }
    
    public func updateUserStreak() throws {
        guard let user = getCurrentUserEntity() else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        if let lastCheckIn = user.lastCheckIn {
            let isNextDay = calendar.isDate(now, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: lastCheckIn) ?? now)
            let isToday = calendar.isDateInToday(lastCheckIn)
            
            if isNextDay {
                user.streak += 1
            } else if !isToday {
                user.streak = 0
            }
        }
        
        user.lastCheckIn = now
        try context.save()
    }
    
    public func getAllTransactions() -> [TransactionEntity] {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    public func addTransaction(_ transaction: Transaction) throws {
        let entity = TransactionEntity(context: context)
        entity.idString = transaction.id.uuidString
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        entity.note = transaction.note
        
        if let user = getCurrentUserEntity() {
            user.totalSavings += transaction.amount
        }
        
        try context.save()
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.predicate = NSPredicate(format: "idString == %@", transaction.id.uuidString)
        request.fetchLimit = 1
        
        if let entity = try context.fetch(request).first {
            if let user = getCurrentUserEntity() {
                user.totalSavings -= entity.amount
            }
            
            context.delete(entity)
            try context.save()
        }
    }
    
    @MainActor
    public func reset() {
        // Get the main context
        let context = persistentContainer.viewContext
        
        do {
            // Fetch and delete all entities
            let entityNames = ["UserProfileEntity", "TransactionEntity", "CravingEntity"]
            
            for entityName in entityNames {
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
                let objects = try context.fetch(fetchRequest)
                
                for object in objects {
                    context.delete(object)
                }
            }
            
            // Save changes
            try context.save()
            
            // Reset the context
            context.reset()
            
            // Get the store URL
            guard let storeURL = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
                print("No persistent store URL found")
                return
            }
            
            // Remove the store
            try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            
            // Create a new store
            try persistentContainer.persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )
        } catch {
            print("Error resetting Core Data: \(error)")
            
            // If reset fails, recreate the container
            persistentContainer = NSPersistentContainer(name: "BetFreeModel")
            persistentContainer.loadPersistentStores { description, error in
                if let error = error {
                    print("Unable to load persistent stores: \(error)")
                }
            }
        }
    }
    
    // MARK: - Craving Management
    
    public func createCraving(intensity: Int, triggers: String, strategies: String, timestamp: Date, duration: Int) async throws -> Craving {
        let entity = CravingEntity(context: context)
        entity.id = UUID()
        entity.intensity = Int32(intensity)
        entity.triggers = triggers
        entity.strategies = strategies
        entity.timestamp = timestamp
        entity.duration = Int32(duration)
        
        try context.save()
        
        return Craving(
            id: entity.id!,
            intensity: Int(entity.intensity),
            trigger: triggers,
            location: nil,
            emotion: nil,
            duration: TimeInterval(duration),
            copingStrategy: strategies,
            outcome: nil
        )
    }
    
    public func getCravings() async throws -> [Craving] {
        let request = CravingEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CravingEntity.timestamp, ascending: false)]
        
        let entities = try context.fetch(request)
        return entities.map { entity in
            Craving(
                id: entity.id!,
                intensity: Int(entity.intensity),
                trigger: entity.triggers ?? "",
                location: nil,
                emotion: nil,
                duration: TimeInterval(entity.duration),
                copingStrategy: entity.strategies,
                outcome: nil
            )
        }
    }
    
    public func deleteCraving(id: UUID) async throws {
        let request = CravingEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    // MARK: - Transaction Management
    
    public func getAllTransactions() -> [Transaction] {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        let entities = (try? context.fetch(request)) ?? []
        
        return entities.map { entity in
            Transaction(
                id: UUID(uuidString: entity.idString ?? "") ?? UUID(),
                amount: entity.amount,
                category: TransactionCategory(rawValue: entity.category ?? "") ?? .other,
                date: entity.date ?? Date(),
                note: entity.note
            )
        }
    }
}