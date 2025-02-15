import Foundation

public struct Transaction: Identifiable {
    public let id: UUID
    public let amount: Double
    public let date: Date
    public let category: String
    public let note: String?
    
    public init(id: UUID, amount: Double, date: Date, category: String, note: String?) {
        self.id = id
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
    
    init(from entity: TransactionEntity) {
        self.id = entity.id
        self.amount = entity.amount
        self.date = entity.date
        self.category = entity.category
        self.note = entity.note
    }
}
