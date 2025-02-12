import Foundation
import SwiftUI

@MainActor
public class AppState: ObservableObject {
    @Published public var username: String {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
        }
    }
    
    @Published public var currentStreak: Int {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.updateUserStreak()
        }
    }
    
    @Published public var totalSavings: Double {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.updateTotalSavings(amount: totalSavings)
        }
    }
    
    @Published public var dailyLimit: Double {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
        }
    }
    
    @Published public var isOnboarded: Bool {
        didSet { saveToUserDefaults() }
    }
    
    @Published public var selectedTab: Int {
        didSet { saveToUserDefaults() }
    }
    
    // Computed properties for UI
    public var streak: Int { currentStreak }
    public var savings: Double { totalSavings }
    
    public init() {
        // Load from UserDefaults first
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        self.totalSavings = UserDefaults.standard.double(forKey: "totalSavings")
        self.dailyLimit = UserDefaults.standard.double(forKey: "dailyLimit")
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
        self.selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
        
        // Then try to load from Core Data
        if let user = CoreDataManager.shared.getCurrentUser() {
            self.username = user.name
            self.currentStreak = Int(user.streak)
            self.totalSavings = user.totalSavings
            self.dailyLimit = user.dailyLimit
        } else {
            // Create initial user profile in Core Data
            try? CoreDataManager.shared.createOrUpdateUser(
                name: username,
                email: nil,
                dailyLimit: dailyLimit
            )
        }
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
    }
    
    public func updateSavings(_ amount: Double) {
        self.totalSavings = amount
    }
    
    public func updateDailyLimit(_ newLimit: Double) {
        self.dailyLimit = newLimit
    }
    
    public func updateUsername(_ newUsername: String) {
        self.username = newUsername
    }
    
    public func completeOnboarding() {
        isOnboarded = true
    }
    
    public func selectTab(_ tab: Int) {
        selectedTab = tab
    }
    
    public func logout() {
        // Reset all user data
        username = ""
        currentStreak = 0
        totalSavings = 0
        dailyLimit = 0
        isOnboarded = false
        selectedTab = 0
        
        // Reset UserDefaults
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "totalSavings")
        UserDefaults.standard.removeObject(forKey: "dailyLimit")
        UserDefaults.standard.removeObject(forKey: "isOnboarded")
        UserDefaults.standard.removeObject(forKey: "selectedTab")
        
        // Reset Core Data
        CoreDataManager.shared.reset()
    }
} 