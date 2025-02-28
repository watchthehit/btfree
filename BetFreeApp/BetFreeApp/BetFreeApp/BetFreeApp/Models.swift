import Foundation

struct CravingReport: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var intensity: Int
    var trigger: String?
    var notes: String?
    var didGiveIn: Bool
    var location: String?
    var duration: TimeInterval?
    
    init(
        date: Date = Date(),
        intensity: Int,
        trigger: String? = nil,
        notes: String? = nil,
        didGiveIn: Bool = false,
        location: String? = nil,
        duration: TimeInterval? = nil
    ) {
        self.date = date
        self.intensity = intensity
        self.trigger = trigger
        self.notes = notes
        self.didGiveIn = didGiveIn
        self.location = location
        self.duration = duration
    }
}

struct DailyProgress: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var mindfulnessMinutes: Int
    var cravingsReported: Int
    var cravingsResisted: Int
    var goalCompleted: Bool
    
    init(
        date: Date = Date(),
        mindfulnessMinutes: Int = 0,
        cravingsReported: Int = 0,
        cravingsResisted: Int = 0,
        goalCompleted: Bool = false
    ) {
        self.date = date
        self.mindfulnessMinutes = mindfulnessMinutes
        self.cravingsReported = cravingsReported
        self.cravingsResisted = cravingsResisted
        self.goalCompleted = goalCompleted
    }
}

struct MindfulnessExercise: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var durationMinutes: Int
    var steps: [String]
    var category: ExerciseCategory
    
    enum ExerciseCategory: String, Codable, CaseIterable {
        case breathing = "Breathing"
        case meditation = "Meditation"
        case bodyAwareness = "Body Awareness"
        case gratitude = "Gratitude"
        case urgeManagement = "Urge Management"
    }
}

struct UserAchievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var dateEarned: Date
    var iconName: String
    
    init(title: String, description: String, dateEarned: Date = Date(), iconName: String) {
        self.title = title
        self.description = description
        self.dateEarned = dateEarned
        self.iconName = iconName
    }
}

// Extension to provide sample data for previews
extension MindfulnessExercise {
    static let samples: [MindfulnessExercise] = [
        MindfulnessExercise(
            id: UUID(),
            title: "Deep Breathing",
            description: "A simple exercise to calm your mind through focused breathing.",
            durationMinutes: 5,
            steps: [
                "Find a comfortable position sitting or lying down",
                "Breathe in slowly through your nose for 4 counts",
                "Hold your breath for 2 counts",
                "Exhale slowly through your mouth for 6 counts",
                "Repeat for 5 minutes"
            ],
            category: .breathing
        ),
        MindfulnessExercise(
            id: UUID(),
            title: "Urge Surfing",
            description: "Learn to ride the wave of a craving without giving in.",
            durationMinutes: 10,
            steps: [
                "Notice the urge without judgment",
                "Pay attention to the physical sensations in your body",
                "Imagine the urge as a wave that rises, peaks, and eventually subsides",
                "Continue breathing normally as you ride the wave",
                "Notice as the intensity decreases over time"
            ],
            category: .urgeManagement
        ),
        MindfulnessExercise(
            id: UUID(),
            title: "Gratitude Practice",
            description: "Shift your focus to the positive aspects of your life.",
            durationMinutes: 7,
            steps: [
                "Find a quiet place to sit",
                "Close your eyes and take several deep breaths",
                "Think of three things you're grateful for today",
                "For each one, spend a minute reflecting on why it brings you joy",
                "Notice how your mood shifts as you focus on gratitude"
            ],
            category: .gratitude
        )
    ]
} 