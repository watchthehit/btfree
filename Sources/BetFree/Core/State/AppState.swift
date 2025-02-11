import SwiftUI

@MainActor
public class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var username: String
    @Published public var currentStreak: Int
    @Published public var totalSavings: Double
    @Published public var dailyLimit: Double
    @Published public var isOnboarded: Bool
    @Published public var selectedTab: Int
    
    public init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        self.totalSavings = UserDefaults.standard.double(forKey: "totalSavings")
        self.dailyLimit = UserDefaults.standard.double(forKey: "dailyLimit")
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
        self.selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalSavings, forKey: "totalSavings")
        UserDefaults.standard.set(dailyLimit, forKey: "dailyLimit")
        UserDefaults.standard.set(isOnboarded, forKey: "isOnboarded")
        UserDefaults.standard.set(selectedTab, forKey: "selectedTab")
    }
    
    public func updateStreak(_ newStreak: Int) {
        self.currentStreak = newStreak
        saveToUserDefaults()
    }
    
    public func updateSavings(_ amount: Double) {
        self.totalSavings = amount
        saveToUserDefaults()
    }
    
    public func updateDailyLimit(_ newLimit: Double) {
        self.dailyLimit = newLimit
        saveToUserDefaults()
    }
    
    public func updateUsername(_ newUsername: String) {
        self.username = newUsername
        saveToUserDefaults()
    }
    
    public func completeOnboarding() {
        isOnboarded = true
        saveToUserDefaults()
    }
    
    public func selectTab(_ tab: Int) {
        selectedTab = tab
        saveToUserDefaults()
    }
} 