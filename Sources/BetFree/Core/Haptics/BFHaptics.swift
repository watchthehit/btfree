import SwiftUI

#if os(iOS)
import UIKit

public enum BFHaptics {
    public static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    public static func notification(type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    public static func softTap() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        #endif
    }
    
    public static func mediumTap() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
    
    public static func heavyTap() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #endif
    }
    
    public static func success() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
    
    public static func error() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }
    
    public static func warning() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        #endif
    }
}

public extension View {
    /// Adds haptic feedback when a button is pressed
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.impact(style: style)
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType = .success) -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.notification(type: type)
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticSelection() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.selection()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticSoftTap() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.softTap()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticMediumTap() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.mediumTap()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticHeavyTap() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.heavyTap()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticSuccess() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.success()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticError() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.error()
        })
    }
    
    /// Adds haptic feedback when a button is pressed
    func hapticWarning() -> some View {
        self.simultaneousGesture(TapGesture().onEnded { _ in
            BFHaptics.warning()
        })
    }
}
#else
public enum BFHaptics {
    public static func impact() {}
    public static func notification() {}
    public static func selection() {}
    public static func softTap() {}
    public static func mediumTap() {}
    public static func heavyTap() {}
    public static func success() {}
    public static func error() {}
    public static func warning() {}
}

public extension View {
    func hapticFeedback() -> some View { self }
    func hapticNotification() -> some View { self }
    func hapticSelection() -> some View { self }
    func hapticSoftTap() -> some View { self }
    func hapticMediumTap() -> some View { self }
    func hapticHeavyTap() -> some View { self }
    func hapticSuccess() -> some View { self }
    func hapticError() -> some View { self }
    func hapticWarning() -> some View { self }
}
#endif
