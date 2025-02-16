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
        // Create an in-memory store description
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        
        // Initialize the container with the model from the bundle
        let container = NSPersistentContainer(name: "BetFreeModel")
        container.persistentStoreDescriptions = [storeDescription]
        
        // Load the persistent store synchronously
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading persistent store: \(error)")
                fatalError("Failed to load Core Data stack")
            }
        }
        
        // Configure the context
        self.context = container.viewContext
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    public func getCurrentUser() -> UserProfileEntity? {
        userProfile
    }
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        do {
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
            
            if context.hasChanges {
                try context.save()
                print("Successfully saved user data")
            }
        } catch {
            print("Error saving user data: \(error)")
            context.rollback()
            throw error
        }
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