import SwiftUI
import Foundation

// MARK: - Enums
public enum TrackingMethod: String, CaseIterable, Identifiable {
    case automatic = "Let the app monitor your activity and detect potential risks"
    case manual = "Log your activities and feelings manually at your own pace"
    case hybrid = "Combine automatic monitoring with manual check-ins"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .automatic: return "antenna.radiowaves.left.and.right"
        case .manual: return "pencil.and.list.clipboard"
        case .hybrid: return "arrow.triangle.2.circlepath"
        }
    }
    
    public var description: String {
        switch self {
        case .automatic:
            return "Let the app monitor your activity and detect potential risks"
        case .manual:
            return "Log your activities and feelings manually at your own pace"
        case .hybrid:
            return "Combine automatic monitoring with manual check-ins"
        }
    }
}

public enum Weekday: String, CaseIterable, Identifiable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
    
    public var id: String { rawValue }
}

// MARK: - Support Types
public struct TriggerCategory: Identifiable {
    public var id = UUID()
    public var name: String
    public var triggers: [String]
    
    public init(name: String, triggers: [String]) {
        self.name = name
        self.triggers = triggers
    }
}

// MARK: - SubscriptionPlanCard
struct SubscriptionPlanCard: View {
    let isSelected: Bool
    let planName: String
    let price: String
    let period: String
    let savings: String
    let isRecommended: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                if isRecommended {
                    Text("Best Value")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(BFColors.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(BFColors.accent.opacity(0.15))
                        )
                        .padding(.bottom, 4)
                }
                
                Text(planName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(price)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(BFColors.accent)
                
                Text("per \(period)")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                
                if !savings.isEmpty {
                    Text(savings)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(BFColors.accent)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(BFColors.accent.opacity(0.15))
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(isSelected ? 0.12 : 0.08))
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(BFColors.accent, lineWidth: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    }
                }
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
    }
} 