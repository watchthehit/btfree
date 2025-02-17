import Foundation

public struct Craving: Identifiable, Codable {
    public let id: UUID
    public let intensity: Int
    public let triggers: String
    public let strategies: String
    public let timestamp: Date
    public let duration: Int
    
    public init(
        id: UUID = UUID(),
        intensity: Int,
        triggers: String,
        strategies: String,
        timestamp: Date,
        duration: Int
    ) {
        self.id = id
        self.intensity = intensity
        self.triggers = triggers
        self.strategies = strategies
        self.timestamp = timestamp
        self.duration = duration
    }
} 