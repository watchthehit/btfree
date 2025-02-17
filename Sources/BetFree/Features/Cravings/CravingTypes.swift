import SwiftUI

public enum CopingStrategy: String, CaseIterable, Identifiable {
    case deepBreathing = "Deep Breathing"
    case physicalActivity = "Physical Activity"
    case mindfulness = "Mindfulness"
    case journaling = "Journaling"
    case talkingToAFriend = "Talking to a Friend"
    case seekingProfessionalHelp = "Seeking Professional Help"
    
    public var id: String { rawValue }
    public var title: String { rawValue }
    
    public var description: String {
        switch self {
        case .deepBreathing:
            return "Take slow, deep breaths to calm your mind and body."
        case .physicalActivity:
            return "Engage in physical activity to distract yourself and release endorphins."
        case .mindfulness:
            return "Focus on the present moment and let go of cravings."
        case .journaling:
            return "Write down your thoughts and feelings to process and release them."
        case .talkingToAFriend:
            return "Reach out to a friend or loved one for support and connection."
        case .seekingProfessionalHelp:
            return "Seek help from a professional counselor or therapist."
        }
    }
    
    public var iconName: String {
        switch self {
        case .deepBreathing:
            return "heart"
        case .physicalActivity:
            return "figure.walk"
        case .mindfulness:
            return "mindfulness"
        case .journaling:
            return "pencil.tip"
        case .talkingToAFriend:
            return "person.2"
        case .seekingProfessionalHelp:
            return "briefcase"
        }
    }
}

public enum Trigger: String, CaseIterable, Identifiable {
    case boredom = "Boredom"
    case stress = "Stress"
    case social = "Social Pressure"
    case ads = "Betting Ads"
    case money = "Money Problems"
    case wins = "Past Wins"
    case losses = "Past Losses"
    case excitement = "Need Excitement"
    
    public var id: String { rawValue }
    public var name: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .boredom: return "hourglass"
        case .stress: return "bolt.fill"
        case .social: return "person.2.fill"
        case .ads: return "megaphone.fill"
        case .money: return "dollarsign.circle.fill"
        case .wins: return "trophy.fill"
        case .losses: return "arrow.down.circle.fill"
        case .excitement: return "star.fill"
        }
    }
} 