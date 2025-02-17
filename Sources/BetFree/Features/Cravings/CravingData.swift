import Foundation

struct CravingData: Identifiable, Codable {
    let id: UUID
    let intensity: Int
    let triggers: String
    let strategies: String
    let timestamp: Date
    let duration: Int
    
    init(intensity: Int, triggers: String, strategies: String, timestamp: Date, duration: Int) {
        self.id = UUID()
        self.intensity = intensity
        self.triggers = triggers
        self.strategies = strategies
        self.timestamp = timestamp
        self.duration = duration
    }
    
    var triggerArray: [Trigger] {
        triggers.split(separator: ",").compactMap { Trigger(rawValue: String($0)) }
    }
    
    var strategyArray: [CopingStrategy] {
        strategies.split(separator: ",").compactMap { CopingStrategy(rawValue: String($0)) }
    }
} 