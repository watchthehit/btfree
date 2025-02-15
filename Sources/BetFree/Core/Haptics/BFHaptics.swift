import SwiftUI
import CoreHaptics

public enum BFHaptics {
    // MARK: - Basic Feedback
    
    /// Trigger success feedback (e.g., when completing a goal)
    public static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    /// Trigger error feedback (e.g., when exceeding daily limit)
    public static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    /// Trigger warning feedback (e.g., when approaching daily limit)
    public static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    // MARK: - Interactive Feedback
    
    /// Light tap feedback for subtle interactions
    public static func lightTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    /// Medium tap feedback for standard interactions
    public static func mediumTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Heavy tap feedback for emphasized interactions
    public static func heavyTap() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    /// Soft tap feedback for gentle interactions
    public static func softTap() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    /// Rigid tap feedback for firm interactions
    public static func rigidTap() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    // MARK: - Selection Feedback
    
    /// Selection changed feedback
    public static func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds haptic feedback when a button is pressed
    func withHaptics(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        })
    }
    
    /// Adds success haptic feedback when a condition is met
    func withSuccessHaptics(when condition: Bool) -> some View {
        onChange(of: condition) { newValue in
            if newValue {
                BFHaptics.success()
            }
        }
    }
    
    /// Adds error haptic feedback when a condition is met
    func withErrorHaptics(when condition: Bool) -> some View {
        onChange(of: condition) { newValue in
            if newValue {
                BFHaptics.error()
            }
        }
    }
}

// MARK: - Advanced Haptic Engine

public class BFHapticEngine {
    private var engine: CHHapticEngine?
    
    public init() {
        setupHapticEngine()
    }
    
    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Creation Error: \(error.localizedDescription)")
        }
    }
    
    /// Play a custom achievement pattern
    public func playAchievementPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        do {
            let pattern = try createAchievementPattern()
            try engine.start()
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Pattern Play Error: \(error.localizedDescription)")
        }
    }
    
    /// Play a custom progress completion pattern
    public func playProgressCompletionPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        do {
            let pattern = try createProgressCompletionPattern()
            try engine.start()
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Pattern Play Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Pattern Creation
    
    private func createAchievementPattern() throws -> CHHapticPattern {
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1.0)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: 0.5, value: 0.0)
        
        let parameter = CHHapticParameterCurve(
            parameterID: .hapticIntensityControl,
            controlPoints: [start, end],
            relativeTime: 0
        )
        
        let event1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        
        let event2 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0.1,
            duration: 0.4
        )
        
        return try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
    }
    
    private func createProgressCompletionPattern() throws -> CHHapticPattern {
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        
        let events = (0...2).map { i -> CHHapticEvent in
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: TimeInterval(i) * 0.1
            )
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
}
