import Foundation

public enum TransactionCategory: String, CaseIterable, Identifiable {
    case gambling = "gambling"
    case entertainment = "entertainment"
    case food = "food"
    case shopping = "shopping"
    case other = "other"
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .gambling:
            return "Gambling"
        case .entertainment:
            return "Entertainment"
        case .food:
            return "Food & Drinks"
        case .shopping:
            return "Shopping"
        case .other:
            return "Other"
        }
    }
    
    public var icon: String {
        switch self {
        case .gambling:
            return "dice.fill"
        case .entertainment:
            return "film.fill"
        case .food:
            return "fork.knife"
        case .shopping:
            return "cart.fill"
        case .other:
            return "square.grid.2x2.fill"
        }
    }
}
