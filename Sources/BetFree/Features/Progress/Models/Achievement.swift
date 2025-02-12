import SwiftUI

public struct Achievement: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let icon: String
    public let color: Color
    public let isUnlocked: Bool
    public let progress: Double // 0.0 to 1.0
    
    static let samples = [
        Achievement(
            title: "First Step",
            description: "Complete your first day",
            icon: "figure.walk",
            color: BFDesignSystem.Colors.success,
            isUnlocked: true,
            progress: 1.0
        ),
        Achievement(
            title: "Week Warrior",
            description: "Complete a 7-day streak",
            icon: "star.fill",
            color: BFDesignSystem.Colors.primary,
            isUnlocked: true,
            progress: 1.0
        ),
        Achievement(
            title: "Money Master",
            description: "Save your first $100",
            icon: "dollarsign.circle.fill",
            color: BFDesignSystem.Colors.secondary,
            isUnlocked: false,
            progress: 0.75
        ),
        Achievement(
            title: "Monthly Marvel",
            description: "Complete a 30-day streak",
            icon: "crown.fill",
            color: BFDesignSystem.Colors.accent,
            isUnlocked: false,
            progress: 0.3
        )
    ]
} 