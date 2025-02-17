import Foundation
import CoreData
import BetFreeModels

@MainActor
public protocol BetFreeDataManager {
    var context: NSManagedObjectContext { get }
    
    // User management
    func getCurrentUser() -> UserProfile?
    func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws
    func updateUserStreak() throws
    
    // Transaction management
    func getAllTransactions() -> [Transaction]
    func addTransaction(_ transaction: Transaction) throws
    func deleteTransaction(_ transaction: Transaction) throws
    
    // Craving management
    func createCraving(intensity: Int, triggers: String, strategies: String, timestamp: Date, duration: Int) async throws -> Craving
    func getCravings() async throws -> [Craving]
    func deleteCraving(id: UUID) async throws
    
    // Data management
    func reset()
}
