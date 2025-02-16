import Foundation

public struct Saving: Identifiable, Codable {
    public let id: UUID
    public let amount: Double
    public let date: Date
    public let sport: String
    public let notes: String?
    
    public init(id: UUID = UUID(), amount: Double, date: Date, sport: String, notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.date = date
        self.sport = sport
        self.notes = notes
    }
}

extension Saving: Equatable {
    public static func == (lhs: Saving, rhs: Saving) -> Bool {
        lhs.id == rhs.id
    }
}

extension Saving: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
