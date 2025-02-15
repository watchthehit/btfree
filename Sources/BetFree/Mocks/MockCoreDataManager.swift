import Foundation
import CoreData

// Removed the local DataManager protocol and dummy UserProfile definition

public final class MockCoreDataManager: BetFreeDataManager {
    public static let shared = MockCoreDataManager()
    
    public let context: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "BetFreeModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        self.context = persistentContainer.viewContext
    }
    
    public func getCurrentUser() -> UserProfileEntity? {
        // For testing purposes, return nil to simulate no user present
        return nil
    }
    
    public func createOrUpdateUser(name: String?, email: String?, dailyLimit: Double) throws {
        // Dummy implementation: do nothing
    }
    
    public func updateUserStreak() throws {
        // Dummy implementation: do nothing
    }
    
    public func updateTotalSavings(amount: Double) throws {
        // Dummy implementation: do nothing
    }
    
    public func addTransaction(amount: Double, note: String?) throws {
        // Dummy implementation: do nothing
    }
    
    public func getTodaysTransactions() -> [Transaction] {
        return []
    }
    
    public func getTotalSpentToday() -> Double {
        return 0.0
    }
    
    public func save() throws {
        // Dummy implementation: do nothing
    }
    
    public func reset() {
        // Dummy implementation: do nothing
    }
} 