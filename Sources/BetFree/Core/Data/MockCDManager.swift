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
        let container = NSPersistentContainer(name: "BetFree")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
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
                id: entity.id,
                amount: entity.amount,
                category: TransactionCategory(rawValue: entity.category) ?? .other,
                date: entity.date,
                note: entity.note
            )
        }
    }
    
    public func addTransaction(_ transaction: Transaction) throws {
        let entity = TransactionEntity(context: context)
        entity.id = transaction.id
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        entity.note = transaction.note
        
        transactions.append(entity)
        try context.save()
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
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
    
    public func reset() {
        userProfile = nil
        transactions.removeAll()
        cravings.removeAll()
        try? context.save()
    }
}