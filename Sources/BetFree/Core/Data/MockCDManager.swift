import Foundation
import CoreData
import BetFreeModels

@MainActor
public class MockCDManager: BetFreeDataManager {
    public static let shared = MockCDManager()
    
    private var userProfile: UserProfileEntity?
    private var transactions: [TransactionEntity] = []
    public var context: NSManagedObjectContext
    
    public init() {
        let container = NSPersistentContainer(name: "BetFreeModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, _ in }
        self.context = container.viewContext
    }
    
    public func getCurrentUser() -> UserProfileEntity? {
        userProfile
    }
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        if let existingUser = userProfile {
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
            userProfile = user
        }
        
        try context.save()
    }
    
    public func getAllTransactions() -> [TransactionEntity] {
        transactions
    }
    
    public func addTransaction(_ transaction: Transaction) throws {
        let entity = TransactionEntity(context: context)
        entity.idString = transaction.id.uuidString
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        entity.note = transaction.note
        
        transactions.append(entity)
        
        if let user = userProfile {
            user.totalSavings += transaction.amount
        }
        
        try context.save()
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        if let index = transactions.firstIndex(where: { $0.idString == transaction.id.uuidString }) {
            let entity = transactions[index]
            
            if let user = userProfile {
                user.totalSavings -= entity.amount
            }
            
            context.delete(entity)
            transactions.remove(at: index)
            try context.save()
        }
    }
    
    public func updateUserStreak() throws {
        guard let user = userProfile else { return }
        
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
    
    public func reset() {
        userProfile = nil
        transactions.removeAll()
        try? context.save()
    }
}