import SwiftUI

public class AppState: ObservableObject {
    @Published public var selectedTab: Int = 0
    @Published public var isOnboarded: Bool = false
    @Published public var streak: Int = 0
    @Published public var savings: Double = 0
    @Published public var isSubscribed: Bool = false
    @Published public var username: String = ""
    @Published public var dailyLimit: Double = 0
    
    public init() {}
    
    public func completeOnboarding() {
        isOnboarded = true
    }
    
    public func updateStreak(_ value: Int) {
        streak = value
    }
    
    public func updateSavings(_ value: Double) {
        savings = value
    }
    
    public func updateUsername(_ value: String) {
        username = value
    }
    
    public func updateDailyLimit(_ value: Double) {
        dailyLimit = value
    }
    
    public func subscribe() {
        isSubscribed = true
    }
} 