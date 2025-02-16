import Foundation

public enum TransactionCategory: String, CaseIterable, Identifiable {
    case food = "Food"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case health = "Health"
    case education = "Education"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .food:
            return "🍽️"
        case .entertainment:
            return "🎮"
        case .shopping:
            return "🛍️"
        case .transportation:
            return "🚗"
        case .utilities:
            return "💡"
        case .health:
            return "🏥"
        case .education:
            return "📚"
        case .other:
            return "📦"
        }
    }
}
