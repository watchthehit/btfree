import Foundation

public enum Sport: String, Hashable, CaseIterable, Identifiable, Codable {
    case baseball = "Baseball"
    case hockey = "Hockey"
    case soccer = "Soccer"
    case tennis = "Tennis"
    case golf = "Golf"
    case boxing = "Boxing"
    case mma = "MMA"
    case racing = "Racing"
    
    public var id: String { rawValue }
    
    public var name: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .baseball: return "baseball"
        case .hockey: return "hockey.puck"
        case .soccer: return "soccerball"
        case .tennis: return "tennis.racket"
        case .golf: return "figure.golf"
        case .boxing: return "figure.boxing"
        case .mma: return "figure.boxing"
        case .racing: return "car"
        }
    }
} 