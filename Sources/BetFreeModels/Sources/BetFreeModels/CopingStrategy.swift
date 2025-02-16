import Foundation

public enum CopingStrategy: String, CaseIterable, Identifiable, Hashable {
    case breathe
    case walk
    case distract
    case urgeSurf
    case meditation
    case exercise
    case callFriend
    case journal
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .breathe: return "Take Deep Breaths"
        case .walk: return "Go for a Walk"
        case .distract: return "Find a Distraction"
        case .urgeSurf: return "Practice Urge Surfing"
        case .meditation: return "Meditate"
        case .exercise: return "Exercise"
        case .callFriend: return "Call a Friend"
        case .journal: return "Write in Journal"
        }
    }
    
    public var description: String {
        switch self {
        case .breathe: return "Breathe in for 4 seconds, hold for 4, out for 4"
        case .walk: return "A 5-minute walk can help clear your mind"
        case .distract: return "Play a game, read, or do a hobby"
        case .urgeSurf: return "Observe the urge without acting on it"
        case .meditation: return "Take 5 minutes to center yourself"
        case .exercise: return "Get your body moving"
        case .callFriend: return "Reach out to your support system"
        case .journal: return "Write about your feelings and triggers"
        }
    }
    
    public var iconName: String {
        switch self {
        case .breathe: return "wind"
        case .walk: return "figure.walk"
        case .distract: return "gamecontroller"
        case .urgeSurf: return "wave.3.right"
        case .meditation: return "brain.head.profile"
        case .exercise: return "figure.run"
        case .callFriend: return "phone.fill"
        case .journal: return "book.fill"
        }
    }
}
