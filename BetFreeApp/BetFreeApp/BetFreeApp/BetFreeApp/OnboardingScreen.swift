import SwiftUI

enum OnboardingScreen: Equatable {
    // New PuffCount-inspired flow (now the primary flow)
    case welcome
    case goalSelection
    case trackingMethodSelection
    case triggerIdentification
    case scheduleSetup
    case profileCompletion
    
    // Account creation and finalization (kept from original flow)
    case signIn
    case personalSetup
    case notificationSetup
    case paywall
    case completion
}
