import Foundation

public enum BFUserState: Codable, Equatable {
    case trial(endDate: Date)
    case subscribed(expiryDate: Date)
    case expired
    case needsRestore
    
    private enum CodingKeys: String, CodingKey {
        case type, endDate, expiryDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(Int.self, forKey: .type)
        
        switch type {
        case 1:
            let endDate = try container.decode(Date.self, forKey: .endDate)
            self = .trial(endDate: endDate)
        case 2:
            let expiryDate = try container.decode(Date.self, forKey: .expiryDate)
            self = .subscribed(expiryDate: expiryDate)
        case 3:
            self = .expired
        case 4:
            self = .needsRestore
        default:
            self = .expired
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .trial(let endDate):
            try container.encode(1, forKey: .type)
            try container.encode(endDate, forKey: .endDate)
        case .subscribed(let expiryDate):
            try container.encode(2, forKey: .type)
            try container.encode(expiryDate, forKey: .expiryDate)
        case .expired:
            try container.encode(3, forKey: .type)
        case .needsRestore:
            try container.encode(4, forKey: .type)
        }
    }
} 