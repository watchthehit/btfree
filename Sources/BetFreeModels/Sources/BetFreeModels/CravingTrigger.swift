import Foundation

public enum CravingTrigger: String, CaseIterable, Identifiable, Hashable {
    case boredom
    case stress
    case socialPressure
    case excitement
    case loneliness
    case celebration
    case anxiety
    case depression
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .boredom: return "Boredom"
        case .stress: return "Stress"
        case .socialPressure: return "Social Pressure"
        case .excitement: return "Excitement"
        case .loneliness: return "Loneliness"
        case .celebration: return "Celebration"
        case .anxiety: return "Anxiety"
        case .depression: return "Depression"
        }
    }
    
    public var iconName: String {
        switch self {
        case .boredom: return "hourglass"
        case .stress: return "bolt.fill"
        case .socialPressure: return "person.2.fill"
        case .excitement: return "star.fill"
        case .loneliness: return "person.fill.questionmark"
        case .celebration: return "party.popper.fill"
        case .anxiety: return "heart.fill"
        case .depression: return "cloud.rain.fill"
        }
    }
}
