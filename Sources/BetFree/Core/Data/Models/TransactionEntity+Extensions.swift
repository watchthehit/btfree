import Foundation
import CoreData
import BetFreeModels

extension TransactionEntity {
    var transaction: Transaction {
        Transaction(
            id: UUID(uuidString: idString ?? "") ?? UUID(),
            amount: amount,
            category: TransactionCategory(rawValue: category ?? "") ?? .other,
            date: date ?? Date(),
            note: note
        )
    }
    
    static func create(from transaction: Transaction, in context: NSManagedObjectContext) -> TransactionEntity {
        let entity = TransactionEntity(context: context)
        entity.idString = transaction.id.uuidString
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        entity.note = transaction.note
        return entity
    }
    
    func update(from transaction: Transaction) {
        idString = transaction.id.uuidString
        amount = transaction.amount
        category = transaction.category.rawValue
        date = transaction.date
        note = transaction.note
    }
} 