import Foundation
import CoreData
@testable import BetFree

@MainActor
public class MockDataManager: DataManager {
    private var user: UserProfile?
    private var transactions: [Transaction] = []
    private let managedContext: NSManagedObjectContext
    
    public var context: NSManagedObjectContext {
        managedContext
    }
    
    public init(context: NSManagedObjectContext) {
        self.managedContext = context
        self.managedContext.automaticallyMergesChangesFromParent = true
        self.managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    public func getCurrentUser() -> UserProfile? {
        let request = NSFetchRequest<UserProfile>(entityName: "BetFree_UserProfile")
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }
    
    public func createOrUpdateUser(name: String?, email: String?, dailyLimit: Double) throws {
        if user == nil {
            let entity = NSEntityDescription.entity(forEntityName: "BetFree_UserProfile", in: context)!
            user = UserProfile(entity: entity, insertInto: context)
            user?.id = UUID()
            user?.streak = 0
            user?.totalSavings = 0
            user?.savings = 0
            user?.lastCheckIn = nil
            user?.lastLoginDate = Date()
            user?.name = name ?? ""
            user?.email = email ?? ""
            user?.username = name ?? "User"
            user?.dailyLimit = dailyLimit
        } else {
            if let name = name {
                user?.name = name
                user?.username = name
            }
            if let email = email {
                user?.email = email
            }
            user?.dailyLimit = dailyLimit
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func updateUserStreak() throws {
        guard let user = user else { return }
        user.streak += 1
        user.lastCheckIn = Date()
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func updateTotalSavings(amount: Double) throws {
        guard let user = user else { return }
        user.totalSavings += amount
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func addTransaction(amount: Double, note: String?) throws {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = Date()
        transaction.note = note
        transaction.category = amount < 0 ? "Expense" : "Savings"
        transactions.append(transaction)
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func getTodaysTransactions() -> [Transaction] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return transactions.filter { transaction in
            let date = transaction.date
            return date >= startOfDay && date < endOfDay
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
    
    public func reset() {
        // Clear in-memory references
        user = nil
        transactions.removeAll()
        
        // Reset context
        context.reset()
        
        // Perform a batch delete for all entities
        let entities = ["BetFree_UserProfile", "Transaction"]
        entities.forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
            } catch {
                print("Error resetting \(entityName): \(error)")
            }
        }
        
        // Final reset and save
        context.reset()
        try? context.save()
    }
} 