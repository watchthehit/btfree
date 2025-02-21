import Foundation

public enum Sport: String, Hashable, CaseIterable, Identifiable, Codable {
    case football = "Football"
    case basketball = "Basketball"
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
        case .football: return "football"
        case .basketball: return "basketball"
        case .baseball: return "baseball"
        case .hockey: return "hockey.puck"
        case .soccer: return "soccer"
        case .tennis: return "tennis.racket"
        case .golf: return "golf"
        case .boxing: return "figure.boxing"
        case .mma: return "figure.martial.arts"
        case .racing: return "car"
        }
    }
} 