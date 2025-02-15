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
        // Calculate average intensity
        averageIntensity = cravings.isEmpty ? 0 :
            Double(cravings.reduce(0) { $0 + $1.intensity }) / Double(cravings.count)
        
        // Find common triggers
        var triggerCounts: [String: Int] = [:]
        cravings.forEach { craving in
            triggerCounts[craving.trigger, default: 0] += 1
        }
        commonTriggers = triggerCounts
            .sorted { $0.value > $1.value }
            .map { (trigger: $0.key, count: $0.value) }
        
        // Analyze cravings by time
        var hourCounts = Array(repeating: 0, count: 24)
        cravings.forEach { craving in
            let hour = Calendar.current.component(.hour, from: craving.timestamp)
            hourCounts[hour] += 1
        }
        cravingsByTime = hourCounts.enumerated().map { (hour: $0, count: $1) }
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
}

// MARK: - Emotions
public extension CravingManager {
    static let commonEmotions = [
        "Stressed", "Anxious", "Bored", "Lonely", "Excited",
        "Frustrated", "Angry", "Happy", "Sad", "Overwhelmed"
    ]
}

// MARK: - Coping Strategies
public extension CravingManager {
    static let copingStrategies = [
        "Deep breathing",
        "Physical exercise",
        "Call a friend",
        "Mindfulness meditation",
        "Go for a walk",
        "Listen to music",
        "Write in journal",
        "Read a book",
        "Take a shower",
        "Practice hobby"
    ]
}
