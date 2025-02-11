import SwiftUI

public class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var isOnboarded: Bool = false
    @Published public var selectedTab: Int = 0
    
    public init() {
        // Load state from UserDefaults
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
    }
    
    public func completeOnboarding() {
        isOnboarded = true
        UserDefaults.standard.set(true, forKey: "isOnboarded")
    }
    
    public func resetOnboarding() {
        isOnboarded = false
        UserDefaults.standard.set(false, forKey: "isOnboarded")
    }
} 