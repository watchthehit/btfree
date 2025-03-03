import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
public enum TrackingMethod: String, CaseIterable, Identifiable {
    case automatic
    case manual
    case hybrid
    
    public var id: String { rawValue }
    
    public var description: String {
        switch self {
        case .automatic:
            return "Let the app track your progress automatically"
        case .manual:
            return "Track your progress manually"
        case .hybrid:
            return "Combine automatic and manual tracking"
        }
    }
    
    public var icon: Image {
        switch self {
        case .automatic:
            return Image(systemName: "clock.arrow.circlepath")
        case .manual:
            return Image(systemName: "hand.tap")
        case .hybrid:
            return Image(systemName: "arrow.triangle.2.circlepath")
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
public enum Weekday: Int, CaseIterable, Identifiable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    public var id: Int { rawValue }
    
    public var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    public var fullName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
} 