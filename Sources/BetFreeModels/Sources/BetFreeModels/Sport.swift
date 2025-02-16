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
        case .soccer: return "soccerball"
        case .tennis: return "tennis.racket"
        case .golf: return "golf.ball.fill"
        case .mma, .boxing: return "boxing.glove"
        case .cricket: return "cricket.bat"
        case .rugby: return "rugby.ball"
        case .volleyball: return "volleyball.fill"
        }
    }
}
