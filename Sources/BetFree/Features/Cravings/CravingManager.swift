import Foundation

public struct Craving: Codable, Identifiable, Equatable {
    public let id: UUID
    public let timestamp: Date
    public let intensity: Int // 1-5
    public let trigger: String
    public let location: String?
    public let emotion: String?
    public let duration: TimeInterval
    public let copingStrategy: String?
    public let outcome: String?
    
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        intensity: Int,
        trigger: String,
        location: String? = nil,
        emotion: String? = nil,
        duration: TimeInterval,
        copingStrategy: String? = nil,
        outcome: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.intensity = intensity
        self.trigger = trigger
        self.location = location
        self.emotion = emotion
        self.duration = duration
        self.copingStrategy = copingStrategy
        self.outcome = outcome
    }
}

public class CravingManager: ObservableObject {
    @Published public private(set) var cravings: [Craving] = []
    @Published public private(set) var averageIntensity: Double = 0
    @Published public private(set) var commonTriggers: [(trigger: String, count: Int)] = []
    @Published public private(set) var cravingsByTime: [(hour: Int, count: Int)] = []
    @Published public private(set) var totalCravingsResisted: Int = 0
    @Published public private(set) var highRiskDaysSurvived: Int = 0
    
    private let defaults = UserDefaults.standard
    private let cravingsKey = "BFCravings"
    
    public init() {
        loadCravings()
        updateStatistics()
    }
    
    private func loadCravings() {
        if let data = defaults.data(forKey: cravingsKey),
           let decoded = try? JSONDecoder().decode([Craving].self, from: data) {
            cravings = decoded
        }
    }
    
    private func saveCravings() {
        if let encoded = try? JSONEncoder().encode(cravings) {
            defaults.set(encoded, forKey: cravingsKey)
        }
    }
    
    public func add(_ craving: Craving) {
        cravings.append(craving)
        updateStatistics()
        saveCravings()
        
        // Provide haptic feedback based on intensity
        if craving.intensity >= 4 {
            BFHaptics.warning()
        } else {
            BFHaptics.success()
        }
    }
    
    public func update(_ craving: Craving) {
        if let index = cravings.firstIndex(where: { $0.id == craving.id }) {
            cravings[index] = craving
            updateStatistics()
            saveCravings()
        }
    }
    
    private func updateStatistics() {
        // Update average intensity
        if !cravings.isEmpty {
            averageIntensity = Double(cravings.map { $0.intensity }.reduce(0, +)) / Double(cravings.count)
        }
        
        // Update total cravings resisted
        totalCravingsResisted = cravings.count
        
        // Update high risk days survived (days with multiple cravings)
        let calendar = Calendar.current
        let cravingsByDay = Dictionary(grouping: cravings) { craving in
            calendar.startOfDay(for: craving.timestamp)
        }
        highRiskDaysSurvived = cravingsByDay.filter { $0.value.count > 1 }.count
        
        // Update common triggers
        let triggerCounts = Dictionary(grouping: cravings, by: { $0.trigger })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(5)
        commonTriggers = triggerCounts.map { ($0.key, $0.value) }
        
        // Update cravings by time
        let hourCounts = Dictionary(grouping: cravings) { craving in
            calendar.component(.hour, from: craving.timestamp)
        }
        cravingsByTime = (0...23).map { hour in
            (hour: hour, count: hourCounts[hour]?.count ?? 0)
        }
    }
    
    public func getRecentCravings(limit: Int = 7) -> [Craving] {
        Array(cravings.prefix(limit))
    }
    
    public func getCravingTrend() -> Double {
        guard cravings.count >= 2 else { return 0 }
        
        let recentAvg = cravings.prefix(3).reduce(0.0) { $0 + Double($1.intensity) } / 3.0
        let olderAvg = cravings.dropFirst(3).prefix(3).reduce(0.0) { $0 + Double($1.intensity) } / 3.0
        
        return recentAvg - olderAvg
    }
    
    public func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0m"
    }
    
    public func hadCravingOn(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return cravings.contains { craving in
            calendar.isDate(craving.timestamp, inSameDayAs: date)
        }
    }
}

// MARK: - Common Triggers
public extension CravingManager {
    static let commonTriggers = [
        "Live game on TV",
        "Sports betting ad",
        "Friend discussing odds",
        "Upcoming big game",
        "Social media sports content",
        "Fantasy sports update",
        "Sports news/stats",
        "Game day atmosphere",
        "Past betting success memory",
        "Team playing well",
        "Potential parlay opportunity",
        "Close game situation",
        "Underdog story",
        "Championship/playoff game",
        "Free betting credit offer"
    ]
    
    static let commonLocations = [
        "At home watching TV",
        "Sports bar",
        "Friend's house",
        "Stadium/arena",
        "Mobile phone",
        "Computer/laptop",
        "Public transport",
        "Work break room",
        "Restaurant with games on",
        "Gym with sports TV"
    ]
    
    static let commonEmotions = [
        "Excited by close game",
        "Confident in pick",
        "FOMO on big game",
        "Frustrated by loss",
        "Bored during game",
        "Anxious about score",
        "Regret from past bet",
        "Hopeful for comeback",
        "Tempted by odds",
        "Peer pressure"
    ]
}

// MARK: - Coping Strategies
public extension CravingManager {
    static let copingStrategies = [
        "Turn off game/stream",
        "Call recovery sponsor",
        "Block betting apps",
        "Review savings progress",
        "Use breathing technique",
        "Play non-betting game",
        "Exercise/physical activity",
        "Read recovery stories",
        "Message support group",
        "Mindfulness exercise",
        "Review betting losses",
        "Focus on family goals",
        "Practice new hobby",
        "Listen to recovery podcast",
        "Write in recovery journal"
    ]
    
    static let riskySituations = [
        "Big game days",
        "Playoff season",
        "Holiday tournaments",
        "Payday periods",
        "Weekend games",
        "Late-night games",
        "Social viewing events",
        "Sports bar visits",
        "Fantasy draft season",
        "March Madness"
    ]
    
    static func getRiskLevel(for situation: String) -> Int {
        switch situation {
        case "Big game days", "Playoff season", "Payday periods":
            return 5 // Highest risk
        case "Weekend games", "Social viewing events", "Fantasy draft season":
            return 4
        case "Late-night games", "Sports bar visits":
            return 3
        default:
            return 2
        }
    }
    
    func getSafetyPlan(for riskLevel: Int) -> [String] {
        switch riskLevel {
        case 5:
            return [
                "Avoid watching game completely",
                "Stay with support person",
                "Keep betting apps blocked",
                "Have emergency contact ready"
            ]
        case 4:
            return [
                "Watch with recovery buddy",
                "Set strict time limit",
                "Keep devices with friend",
                "Plan alternative activity"
            ]
        case 3:
            return [
                "Enable betting site blocks",
                "Focus on game only",
                "Keep recovery app open",
                "Set check-in schedule"
            ]
        default:
            return [
                "Monitor triggers",
                "Use coping strategies",
                "Stay connected to support",
                "Track progress in app"
            ]
        }
    }
    
    func analyzeRiskPatterns() -> [String: Int] {
        var patterns: [String: Int] = [:]
        
        // Analyze time patterns
        let gameTimeCravings = cravings.filter { craving in
            craving.trigger.contains("game") || craving.trigger.contains("match")
        }
        
        // Count evening/night triggers (typical game times)
        let eveningCravings = cravings.filter { craving in
            let hour = Calendar.current.component(.hour, from: craving.timestamp)
            return hour >= 18 && hour <= 23
        }
        
        patterns["game_time"] = gameTimeCravings.count
        patterns["evening"] = eveningCravings.count
        
        // Analyze social patterns
        let socialTriggers = cravings.filter { craving in
            craving.trigger.contains("friend") || craving.trigger.contains("social") ||
            craving.location?.contains("bar") == true
        }
        patterns["social"] = socialTriggers.count
        
        return patterns
    }
    
    func getProgressInsights() -> [String] {
        var insights: [String] = []
        
        // Analyze trend
        let trend = getCravingTrend()
        if trend < -0.5 {
            insights.append("Your resistance to sports betting urges is improving! Keep using your coping strategies.")
        }
        
        // Analyze patterns
        let patterns = analyzeRiskPatterns()
        if let gameTime = patterns["game_time"], gameTime > 5 {
            insights.append("Live games are a major trigger. Consider watching recorded games instead to avoid betting pressure.")
        }
        
        if let social = patterns["social"], social > 3 {
            insights.append("Social situations increase your risk. Try watching games with your recovery support group.")
        }
        
        // Check coping strategy effectiveness
        let successfulStrategies = cravings
            .filter { $0.copingStrategy != nil && $0.outcome?.contains("passed") == true }
            .compactMap { $0.copingStrategy }
        
        if let bestStrategy = successfulStrategies.mostCommon {
            insights.append("\"\(bestStrategy)\" has been your most effective coping strategy. Keep it up!")
        }
        
        return insights
    }
}

// Helper extension for finding most common element
extension Array where Element: Hashable {
    var mostCommon: Element? {
        let counts = self.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
