import CoreData
import Foundation
import BetFreeModels

public enum BFDataError: Error {
    case entityCreationFailed
    case modelLoadingFailed
    case persistentStoreError
}

@MainActor
public final class CoreDataManager: BetFreeDataManager {
    public static let shared = CoreDataManager()
    
    public static var modelInstance: NSManagedObjectModel?
    
    public let persistenceController: BFPersistenceController
    
    public var persistentContainer: NSPersistentContainer {
        persistenceController.container
    }
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public init() {
        print("🔄 Initializing CoreDataManager")
        self.persistenceController = BFPersistenceController()
    }
    
    private func getCurrentUserEntity() -> UserProfileEntity? {
        let request = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    public func getCurrentUser() -> UserProfile? {
        guard let entity = getCurrentUserEntity() else { return nil }
        return UserProfile(
            name: entity.name,
            email: entity.email,
            streak: Int(entity.streak),
            totalSavings: entity.totalSavings,
            dailyLimit: entity.dailyLimit,
            lastCheckIn: entity.lastCheckIn
        )
    }
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
        fetchRequest.predicate = NSPredicate(format: "idString == %@", name)
        fetchRequest.fetchLimit = 1
        
        do {
            if let existingUser = try context.fetch(fetchRequest).first {
                existingUser.name = name
                existingUser.email = email
                existingUser.dailyLimit = dailyLimit
            } else {
                let user = UserProfileEntity(context: context)
                user.idString = UUID().uuidString
                user.name = name
                user.email = email
                user.dailyLimit = dailyLimit
                user.streak = 0
                user.totalSavings = 0
                user.lastCheckIn = Date()
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("❌ Error creating/updating user: \(error)")
            throw BFDataError.entityCreationFailed
        }
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
    
    public func getAllTransactions() -> [Transaction] {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        
        guard let entities = try? context.fetch(request) else { return [] }
        
        return entities.map { entity in
            Transaction(
                id: UUID(uuidString: entity.idString) ?? UUID(),
                amount: entity.amount,
                category: TransactionCategory(rawValue: entity.category) ?? .other,
                date: entity.date,
                note: entity.note
            )
        }
    }
    
    public func addTransaction(_ transaction: Transaction) throws {
        let entity = TransactionEntity(context: context)
        entity.idString = transaction.id.uuidString
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        entity.note = transaction.note
        
        if let user = getCurrentUserEntity() {
            entity.user = user
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
    
    public func createCraving(intensity: Int, triggers: String, strategies: String, timestamp: Date, duration: Int) async throws -> Craving {
        let entity = CravingEntity(context: context)
        entity.id = UUID()
        entity.intensity = Int16(intensity)
        entity.trigger = triggers
        entity.note = strategies
        entity.date = timestamp
        entity.duration = Int32(duration)
        
        try context.save()
        
        return Craving(
            id: entity.id,
            intensity: Int(entity.intensity),
            trigger: entity.trigger,
            location: entity.location,
            emotion: nil,
            duration: TimeInterval(entity.duration),
            copingStrategy: entity.note,
            outcome: nil
        )
    }
    
    public func getCravings() async throws -> [Craving] {
        let request = NSFetchRequest<CravingEntity>(entityName: "CravingEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CravingEntity.date, ascending: false)]
        
        let entities = try context.fetch(request)
        return entities.map { entity in
            Craving(
                id: entity.id,
                intensity: Int(entity.intensity),
                trigger: entity.trigger,
                location: entity.location,
                emotion: nil,
                duration: TimeInterval(entity.duration),
                copingStrategy: entity.note,
                outcome: nil
            )
        }
    }
    
    public func deleteCraving(id: UUID) async throws {
        let request = NSFetchRequest<CravingEntity>(entityName: "CravingEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    @MainActor
    public func reset() async {
        print("🔄 Starting CoreDataManager reset")
        do {
            let context = persistentContainer.viewContext
            
            // Fetch and delete all entities
            let entityNames = ["UserProfileEntity", "TransactionEntity", "CravingEntity"]
            
            for entityName in entityNames {
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
                let objects = try context.fetch(fetchRequest)
                
                for object in objects {
                    context.delete(object)
                }
            }
            
            try context.save()
            print("✅ CoreDataManager reset complete")
            
        } catch {
            print("❌ Error resetting Core Data: \(error)")
        }
    }
}