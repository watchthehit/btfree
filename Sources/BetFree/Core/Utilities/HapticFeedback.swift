import Foundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
public enum HapticFeedback {
    public enum FeedbackStyle {
        case light
        case medium
        case heavy
        case soft
        case rigid
    }
    
    @MainActor
    private static func impact(style: FeedbackStyle) {
        #if os(iOS)
        let style: UIImpactFeedbackGenerator.FeedbackStyle = {
            switch style {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft: return .soft
            case .rigid: return .rigid
            }
        }()
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    public static func fireAndForget(style: FeedbackStyle = .medium) {
        Task { @MainActor in
            impact(style: style)
        }
    }
} 