import Foundation
import CoreData

@MainActor
public protocol BetFreeDataManager {
    var context: NSManagedObjectContext { get }
    func getCurrentUser() -> UserProfileEntity?
    func createOrUpdateUser(name: String?, email: String?, dailyLimit: Double) throws
    func updateUserStreak() throws
    func updateTotalSavings(amount: Double) throws
    func addTransaction(amount: Double, note: String?) throws
    func getTodaysTransactions() -> [Transaction]
    func getTotalSpentToday() -> Double
    func save() throws
    func reset()
}

// Remove the redundant extension that declares CoreDataManager as conforming to BetFreeDataManager
// extension CoreDataManager: BetFreeDataManager {} 