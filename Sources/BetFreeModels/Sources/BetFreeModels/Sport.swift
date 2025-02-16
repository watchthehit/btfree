import Foundation

public enum Sport: String, CaseIterable, Identifiable {
    case football
    case basketball
    case baseball
    case hockey
    case soccer
    case tennis
    case golf
    case mma
    case boxing
    case cricket
    case rugby
    case volleyball
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .football: return "Football"
        case .basketball: return "Basketball"
        case .baseball: return "Baseball"
        case .hockey: return "Hockey"
        case .soccer: return "Soccer"
        case .tennis: return "Tennis"
        case .golf: return "Golf"
        case .mma: return "MMA"
        case .boxing: return "Boxing"
        case .cricket: return "Cricket"
        case .rugby: return "Rugby"
        case .volleyball: return "Volleyball"
        }
    }
    
    public var iconName: String {
        switch self {
        case .football: return "football.fill"
        case .basketball: return "basketball.fill"
        case .baseball: return "baseball.fill"
        case .hockey: return "hockey.puck.fill"
        case .soccer: return "figure.soccer"
        case .tennis: return "figure.tennis"
        case .golf: return "figure.golf"
        case .mma: return "figure.martial.arts"
        case .boxing: return "figure.boxing"
        case .cricket: return "figure.cricket"
        case .rugby: return "figure.rugby"
        case .volleyball: return "figure.volleyball"
        }
    }
}
