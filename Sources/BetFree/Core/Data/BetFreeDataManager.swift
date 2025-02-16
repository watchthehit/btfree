import Foundation
import CoreData
import BetFreeModels

@MainActor
public protocol BetFreeDataManager {
    var context: NSManagedObjectContext { get }
    
    func getCurrentUser() -> UserProfileEntity?
    func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws
    func updateUserStreak() throws
    func getAllTransactions() -> [TransactionEntity]
    func addTransaction(_ transaction: Transaction) throws
    func deleteTransaction(_ transaction: Transaction) throws
    func reset()
}
