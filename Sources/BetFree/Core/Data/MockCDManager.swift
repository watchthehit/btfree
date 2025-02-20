import Foundation
import CoreData
import BetFreeModels

@MainActor
public class MockCDManager: BetFreeDataManager {
    public static let shared = MockCDManager()
    
    private var userProfile: UserProfileEntity?
    private var transactions: [TransactionEntity] = []
    private var cravings: [CravingEntity] = []
    public var context: NSManagedObjectContext
    private let container: NSPersistentContainer
    
    public init() {
        let model = CoreDataModel.shared.createModel()
        let container = NSPersistentContainer(name: "BetFree", managedObjectModel: model)
        
        // Use in-memory store for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.container = container
        self.context = container.viewContext
    }
    
    public func getCurrentUser() -> UserProfile? {
        guard let entity = userProfile else { return nil }
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
        let user = UserProfileEntity(context: context)
        user.idString = UUID().uuidString
        user.name = name
        user.email = email
        user.dailyLimit = dailyLimit
        user.streak = 0
        user.totalSavings = 0
        user.lastCheckIn = Date()
        
        userProfile = user
        try context.save()
    }
    
    public func updateUserStreak() throws {
        guard let user = userProfile else { return }
        user.streak += 1
        try context.save()
    }
    
    public func getAllTransactions() -> [Transaction] {
        return transactions.map { entity in
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
        
        if let user = userProfile {
            entity.user = user
            user.totalSavings += transaction.amount
        }
        
        transactions.append(entity)
        try context.save()
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        if let index = transactions.firstIndex(where: { $0.idString == transaction.id.uuidString }) {
            context.delete(transactions[index])
            transactions.remove(at: index)
            try context.save()
        }
    }
    
    public func createCraving(intensity: Int, triggers: String, strategies: String, timestamp: Date, duration: Int) async throws -> Craving {
        let entity = CravingEntity(context: context)
        entity.id = UUID()
        entity.intensity = Int16(intensity)
        entity.trigger = triggers
        entity.date = timestamp
        entity.duration = Int32(duration)
        entity.note = strategies
        
        cravings.append(entity)
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
        return cravings.map { entity in
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
        if let index = cravings.firstIndex(where: { $0.id == id }) {
            context.delete(cravings[index])
            cravings.remove(at: index)
            try context.save()
        }
    }
    
    public func reset() {
        userProfile = nil
        transactions.removeAll()
        cravings.removeAll()
        try? context.save()
    }
}