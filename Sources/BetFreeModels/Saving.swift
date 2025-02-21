import Foundation

public struct Saving: Identifiable, Codable, Equatable {
    public let id: UUID
    public let amount: Double
    public let date: Date
    public let sport: Sport
    public let note: String?
    
    public init(
        id: UUID = UUID(),
        amount: Double,
        date: Date = Date(),
        sport: Sport,
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.sport = sport
        self.note = note
    }
} 