import Foundation

public struct UserProfile: Identifiable, Equatable, Hashable {
    public var id: String { name }
    public var name: String
    public var email: String?
    public var streak: Int
    public var totalSavings: Double
    public var dailyLimit: Double
    public var lastCheckIn: Date?
    
    public init(
        name: String,
        email: String? = nil,
        streak: Int = 0,
        totalSavings: Double = 0,
        dailyLimit: Double = 100,
        lastCheckIn: Date? = nil
    ) {
        self.name = name
        self.email = email
        self.streak = streak
        self.totalSavings = totalSavings
        self.dailyLimit = dailyLimit
        self.lastCheckIn = lastCheckIn
    }
}
