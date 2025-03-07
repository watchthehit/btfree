import Foundation
import UIKit

/**
 * HapticManager
 * 
 * Provides standardized haptic feedback throughout the app to enhance the user experience.
 * This class encapsulates UIKit's haptic feedback generators to provide different feedback types.
 */
class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        // Preload generators
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    /// Light haptic feedback for subtle interactions like selections
    func playLightFeedback() {
        lightImpactGenerator.impactOccurred()
    }
    
    /// Medium haptic feedback for more significant interactions
    func playMediumFeedback() {
        mediumImpactGenerator.impactOccurred()
    }
    
    /// Heavy haptic feedback for important events
    func playHeavyFeedback() {
        heavyImpactGenerator.impactOccurred()
    }
    
    /// Selection feedback for UI control interactions
    func playSelectionFeedback() {
        selectionGenerator.selectionChanged()
    }
    
    /// Success feedback for completed actions
    func playSuccessFeedback() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    /// Error feedback for failed actions
    func playErrorFeedback() {
        notificationGenerator.notificationOccurred(.error)
    }
    
    /// Warning feedback for cautionary situations
    func playWarningFeedback() {
        notificationGenerator.notificationOccurred(.warning)
    }
} 