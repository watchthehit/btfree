import Foundation

public struct Transaction: Identifiable, Hashable {
    public let id: UUID
    public let amount: Double
    public let category: TransactionCategory
    public let date: Date
    public let note: String?
    
    public init(id: UUID = UUID(), amount: Double, category: TransactionCategory, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
}
