import Foundation

public struct Saving: Identifiable, Codable, Equatable {
    public let id: UUID
    public let amount: Double
    public let date: Date
    public let sport: Sport
    public let note: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case amount
        case date
        case sport
        case note
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
        sport = try container.decode(Sport.self, forKey: .sport)
        note = try container.decodeIfPresent(String.self, forKey: .note)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(sport, forKey: .sport)
        try container.encodeIfPresent(note, forKey: .note)
    }
    
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