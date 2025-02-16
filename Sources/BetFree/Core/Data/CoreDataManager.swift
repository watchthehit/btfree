import CoreData
import Foundation
import BetFreeModels

@MainActor
public final class CoreDataManager: BetFreeDataManager {
    public static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BetFreeModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to load persistent stores: \(error)")
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
    
    public func getCurrentUser() -> UserProfileEntity? {
        let request = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        if let existingUser = getCurrentUser() {
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
        guard let user = getCurrentUser() else { return }
        
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
        
        if let user = getCurrentUser() {
            user.totalSavings += transaction.amount
        }
        
        try context.save()
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.predicate = NSPredicate(format: "idString == %@", transaction.id.uuidString)
        request.fetchLimit = 1
        
        if let entity = try context.fetch(request).first {
            if let user = getCurrentUser() {
                user.totalSavings -= entity.amount
            }
            
            context.delete(entity)
            try context.save()
        }
    }
    
    public func reset() {
        let fetchRequests = [
            NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfileEntity"),
            NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        ]
        
        for request in fetchRequests {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try? context.execute(deleteRequest)
        }
        
        try? context.save()
    }
}