import Foundation

public struct Transaction: Identifiable, Equatable {
    public let id: UUID
    public let amount: Double
    public let category: TransactionCategory
    public let date: Date
    public let note: String?
    
    public init(
        id: UUID = UUID(),
        amount: Double,
        category: TransactionCategory,
        date: Date = Date(),
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
}

public enum TransactionCategory: String, CaseIterable, Identifiable {
    case food = "Food"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case bills = "Bills"
    case savings = "Savings"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .food: return "🍽️"
        case .entertainment: return "🎮"
        case .shopping: return "🛍️"
        case .bills: return "💰"
        case .savings: return "💵"
        case .other: return "��"
        }
    }
} 