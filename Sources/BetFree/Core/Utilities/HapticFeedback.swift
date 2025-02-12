import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum HapticFeedback {
    @MainActor
    public static func impact(style: FeedbackStyle = .medium) async {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: style.uiStyle)
        generator.impactOccurred()
        #endif
    }
    
    public enum FeedbackStyle {
        case light
        case medium
        case heavy
        case soft
        case rigid
        
        #if os(iOS)
        var uiStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft: return .soft
            case .rigid: return .rigid
            }
        }
        #endif
    }
    
    // Convenience method for fire-and-forget haptic feedback
    public static func fireAndForget(style: FeedbackStyle = .medium) {
        Task { @MainActor in
            await impact(style: style)
        }
    }
} 