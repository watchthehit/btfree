import SwiftUI

/**
 * RecoveryDashboardView - Main dashboard for the BetFree app
 *
 * This screen serves as the main dashboard for users, displaying their recovery
 * progress, daily goals, and mindfulness exercises. It showcases the "Serene Recovery"
 * color scheme and components.
 */
public struct RecoveryDashboardView: View {
    // MARK: - Properties
    
    @State private var selectedTab = 0
    @State private var showingMindfulnessExercise = false
    
    // Sample data
    private let streakDays = 7
    private let completedGoals = 3
    private let totalGoals = 5
    private let mindfulnessMinutes = 45
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome section with gradient background
                    welcomeSection
                    
                    // Progress section
                    progressSection
                    
                    // Daily goals section
                    dailyGoalsSection
                    
                    // Mindfulness exercises section
                    mindfulnessSection
                    
                    // Support resources
                    supportSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("Recovery Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Profile action
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                            .foregroundColor(BFColors.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingMindfulnessExercise) {
            // Mindfulness exercise sheet would go here
            VStack {
                Text("Breathing Exercise")
                    .font(.title)
                    .foregroundColor(BFColors.primary)
                    .padding()
                
                Text("This would be a guided breathing exercise")
                    .foregroundColor(BFColors.textSecondary)
                
                Spacer()
                
                BFButton("Close", action: {
                    showingMindfulnessExercise = false
                })
                .padding()
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    // MARK: - Subviews
    
    /// Welcome section with gradient background
    private var welcomeSection: some View {
        ZStack {
            BFColors.primaryGradient()
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome Back")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("You're making great progress on your recovery journey.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 16) {
                    VStack {
                        Text("\(streakDays)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Day Streak")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .frame(height: 40)
                    
                    VStack {
                        Text("\(completedGoals)/\(totalGoals)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Goals Today")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .frame(height: 40)
                    
                    VStack {
                        Text("\(mindfulnessMinutes)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Mindful Min")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
        .frame(height: 180)
    }
    
    /// Progress section with recovery metrics
    private var progressSection: some View {
        BFCard(title: "Recovery Progress", subtitle: "Last 7 days") {
            VStack(spacing: 16) {
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Urge Control")
                            .font(.subheadline)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Spacer()
                        
                        Text("75%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(BFColors.primary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(BFColors.divider)
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(BFColors.primary)
                                .frame(width: geometry.size.width * 0.75, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Metrics grid
                HStack(spacing: 12) {
                    metricCard(title: "Urge-Free Days", value: "5", icon: "checkmark.circle.fill", color: BFColors.success)
                    
                    metricCard(title: "Avg. Urge Intensity", value: "3.2", icon: "chart.bar.fill", color: BFColors.calm)
                }
                
                BFButton("View Detailed Stats", style: .tertiary, icon: Image(systemName: "chart.xyaxis.line")) {
                    // View stats action
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    /// Daily goals section
    private var dailyGoalsSection: some View {
        BFCard(title: "Today's Recovery Goals", accentColor: BFColors.secondary) {
            VStack(alignment: .leading, spacing: 16) {
                goalRow(title: "Complete morning meditation", isCompleted: true)
                goalRow(title: "Attend support group meeting", isCompleted: true)
                goalRow(title: "Journal about triggers", isCompleted: true)
                goalRow(title: "30 minutes of exercise", isCompleted: false)
                goalRow(title: "Evening reflection", isCompleted: false)
                
                BFButton("Add New Goal", style: .secondary, icon: Image(systemName: "plus")) {
                    // Add goal action
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 8)
        }
    }
    
    /// Mindfulness exercises section
    private var mindfulnessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mindfulness Exercises")
                .font(.headline)
                .foregroundColor(BFColors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    mindfulnessCard(
                        title: "Breathing Exercise",
                        duration: "5 min",
                        color: BFColors.calm,
                        icon: "wind"
                    )
                    
                    mindfulnessCard(
                        title: "Body Scan",
                        duration: "10 min",
                        color: BFColors.focus,
                        icon: "person.fill"
                    )
                    
                    mindfulnessCard(
                        title: "Gratitude Practice",
                        duration: "7 min",
                        color: BFColors.hope,
                        icon: "heart.fill"
                    )
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
        }
    }
    
    /// Support resources section
    private var supportSection: some View {
        BFCard(title: "Support Resources") {
            VStack(spacing: 16) {
                supportRow(title: "24/7 Support Hotline", icon: "phone.fill")
                supportRow(title: "Find Local Meetings", icon: "map.fill")
                supportRow(title: "Chat with Counselor", icon: "message.fill")
                
                BFButton("Emergency Support", style: .destructive, icon: Image(systemName: "exclamationmark.triangle.fill")) {
                    // Emergency support action
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Helper Views
    
    /// Creates a metric card for the progress section
    private func metricCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(BFColors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(BFColors.cardBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(BFColors.divider, lineWidth: 1)
        )
    }
    
    /// Creates a goal row for the daily goals section
    private func goalRow(title: String, isCompleted: Bool) -> some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? BFColors.success : BFColors.textTertiary)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(isCompleted ? BFColors.textSecondary : BFColors.textPrimary)
                .strikethrough(isCompleted)
            
            Spacer()
        }
    }
    
    /// Creates a mindfulness exercise card
    private func mindfulnessCard(title: String, duration: String, color: Color, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(duration)
                    .font(.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
            
            BFButton("Start", style: .tertiary, icon: Image(systemName: "play.fill")) {
                showingMindfulnessExercise = true
            }
        }
        .padding(16)
        .frame(width: 160, height: 180)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
    
    /// Creates a support resource row
    private func supportRow(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(BFColors.primary)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(BFColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(BFColors.textTertiary)
        }
    }
}

// MARK: - Preview

struct RecoveryDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryDashboardView()
    }
} 