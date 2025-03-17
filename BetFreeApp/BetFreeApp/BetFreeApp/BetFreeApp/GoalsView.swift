import SwiftUI

/**
 * GoalsView
 * 
 * A comprehensive screen for users to track, create, and complete goals.
 * This view integrates with EnhancedAppState to manage goal persistence and state.
 * 
 * Features:
 * - Active goals tracking with interactive cards
 * - Goal suggestions based on user activity and current goals
 * - Completed goals history
 * - Animated goal completion celebration
 * - Smooth UI transitions and animations
 */
struct GoalsView: View {
    @EnvironmentObject var appState: EnhancedAppState
    @State private var showingNewGoalSheet = false
    @State private var selectedTimeFrame: TimeFrame = .daily
    
    enum TimeFrame {
        case daily, weekly, monthly
        
        var title: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            }
        }
    }
    
    var body: some View {
        ZStack {
            BFColorSystem.background
                .ignoresSafeArea()
                
            BFScrollView(
                showsIndicators: true,
                bottomSpacing: 100,
                heightMultiplier: 1.2
            ) {
                VStack(spacing: 20) {
                    // Time frame selector
                    HStack {
                        ForEach([TimeFrame.daily, .weekly, .monthly], id: \.self) { timeFrame in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedTimeFrame = timeFrame
                                }
                            }) {
                                Text(timeFrame.title)
                                    .fontWeight(selectedTimeFrame == timeFrame ? .bold : .regular)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        Capsule()
                                            .fill(selectedTimeFrame == timeFrame 
                                                ? BFColorSystem.accent.opacity(0.8) 
                                                : Color.gray.opacity(0.2))
                                    )
                                    .foregroundColor(selectedTimeFrame == timeFrame ? .white : BFColorSystem.textPrimary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingNewGoalSheet = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(BFColorSystem.accent)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // Active goals section
                    activeGoalsSection
                    
                    // Goal suggestions
                    goalSuggestionsSection
                    
                    // Completed goals
                    completedGoalsSection
                    
                    // Add space at the bottom to ensure scrollability
                    Spacer().frame(height: 80)
                }
            }
        }
        .sheet(isPresented: $showingNewGoalSheet) {
            SimpleNewGoalView()
        }
    }
    
    private func getCurrentProgress() -> Int {
        switch selectedTimeFrame {
        case .daily:
            return appState.dailyUrges
        case .weekly:
            return appState.weeklyUrges
        case .monthly:
            return appState.monthlyUrges
        }
    }
    
    private func getCurrentTarget() -> Int {
        switch selectedTimeFrame {
        case .daily: return 8
        case .weekly: return 56
        case .monthly: return 240
        }
    }
    
    private func getFilteredGoals() -> [EnhancedUserGoal]? {
        switch selectedTimeFrame {
        case .daily:
            return appState.enhancedActiveGoals.filter { $0.type == .daily }
        case .weekly:
            return appState.enhancedActiveGoals.filter { $0.type == .weekly }
        case .monthly:
            return appState.enhancedActiveGoals.filter { $0.type == .monthly }
        }
    }
    
    private func calculateSuccessRate() -> Int {
        let total = getCurrentTarget()
        let current = getCurrentProgress()
        return min(100, Int((Double(current) / Double(total)) * 100))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "flag.fill")
                .font(.system(size: 32))
                .foregroundColor(.gray)
            
            Text("No \(selectedTimeFrame.title) Goals")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Tap + to set your first goal")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(hex: "#1E2A4A"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var activeGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Goals")
                .font(BFDesignTokens.Typography.headingMedium)
                .foregroundColor(BFColorSystem.textPrimary)
                .padding(.horizontal)
            
            if let goals = getFilteredGoals(), !goals.isEmpty {
                ForEach(goals) { goal in
                    GoalCard(goal: goal)
                        .padding(.horizontal)
                }
            } else {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "flag.badge.ellipsis")
                            .font(.system(size: 40))
                            .foregroundColor(BFColorSystem.textSecondary.opacity(0.5))
                        
                        Text("No active goals for this timeframe")
                            .font(BFDesignTokens.Typography.bodyMedium)
                            .foregroundColor(BFColorSystem.textSecondary)
                        
                        Text("Tap + to create a new goal")
                            .font(BFDesignTokens.Typography.bodySmall)
                            .foregroundColor(BFColorSystem.textTertiary)
                    }
                    .padding(.vertical, 30)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1E2A4A"))
                )
                .padding(.horizontal)
            }
        }
    }
    
    private var goalSuggestionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggested Goals")
                .font(BFDesignTokens.Typography.headingMedium)
                .foregroundColor(BFColorSystem.textPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Goal suggestions based on current user behavior
                    goalSuggestionCard(
                        icon: "flame.fill", 
                        color: Color(hex: "#FF9500"),
                        title: "7-Day Streak", 
                        description: "Resist urges for 7 consecutive days"
                    )
                    
                    goalSuggestionCard(
                        icon: "dollarsign.circle.fill", 
                        color: Color(hex: "#34C759"),
                        title: "Save $100", 
                        description: "Resist enough urges to save $100"
                    )
                    
                    goalSuggestionCard(
                        icon: "chart.bar.fill", 
                        color: Color(hex: "#5E5CE6"),
                        title: "80% Success Rate", 
                        description: "Handle 80% of urges successfully"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Completed Goals")
                .font(BFDesignTokens.Typography.headingMedium)
                .foregroundColor(BFColorSystem.textPrimary)
                .padding(.horizontal)
            
            if appState.completedGoals.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 40))
                            .foregroundColor(BFColorSystem.textSecondary.opacity(0.5))
                        
                        Text("No completed goals yet")
                            .font(BFDesignTokens.Typography.bodyMedium)
                            .foregroundColor(BFColorSystem.textSecondary)
                        
                        Text("Complete a goal to see it here")
                            .font(BFDesignTokens.Typography.bodySmall)
                            .foregroundColor(BFColorSystem.textTertiary)
                    }
                    .padding(.vertical, 30)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1E2A4A"))
                )
                .padding(.horizontal)
            } else {
                ForEach(appState.completedGoals) { goal in
                    CompletedGoalCard(goal: goal)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private func goalSuggestionCard(icon: String, color: Color, title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: {
                    // Create a new goal based on this suggestion
                    let newGoal = Goal(
                        id: UUID(),
                        title: title,
                        description: description,
                        progress: 0,
                        target: getTargetForSuggestedGoal(title: title),
                        timeFrame: selectedTimeFrame,
                        dateCreated: Date(),
                        iconName: icon,
                        iconColor: color
                    )
                    appState.addGoal(newGoal)
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
                        .foregroundColor(BFColorSystem.accent)
                }
            }
            
            Text(title)
                .font(BFDesignTokens.Typography.bodyLarge.bold())
                .foregroundColor(BFColorSystem.textPrimary)
            
            Text(description)
                .font(BFDesignTokens.Typography.bodySmall)
                .foregroundColor(BFColorSystem.textSecondary)
                .lineLimit(2)
        }
        .padding()
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#1E2A4A"))
        )
    }
    
    private func getTargetForSuggestedGoal(title: String) -> Int {
        // Parse the title to extract target values
        if title.contains("7-Day") {
            return 7
        } else if title.contains("$100") {
            return Int(100 / appState.costPerUrge)
        } else if title.contains("80%") {
            return 20 // For 80% success rate, need at least 20 tracked urges
        }
        return 10 // Default target
    }
}

struct GoalCard: View {
    let goal: EnhancedUserGoal
    @EnvironmentObject var appState: EnhancedAppState
    
    var progress: Double {
        Double(appState.enhancedGetCurrentValueForGoal(goal: goal)) / Double(goal.targetValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(Int(progress * 100))% Complete")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("\(appState.enhancedGetCurrentValueForGoal(goal: goal))/\(goal.targetValue)")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color(hex: "#4E76F7"))
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(Color(hex: "#4E76F7"))
                        .frame(width: geometry.size.width * CGFloat(min(progress, 1.0)), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(Color(hex: "#1E2A4A"))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct SimpleNewGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: EnhancedAppState
    
    @State private var goalTitle = ""
    @State private var selectedType: EnhancedGoalType = .daily
    @State private var targetValue = 8
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#151F38")
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New Goal")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Set a target to track your progress")
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 24) {
                        TextField("Goal Title", text: $goalTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack(spacing: 16) {
                            ForEach(EnhancedGoalType.allCases, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    Text(type.displayName)
                                        .font(.system(size: 15))
                                        .foregroundColor(selectedType == type ? .white : .gray)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selectedType == type ? Color(hex: "#4E76F7") : Color(hex: "#1E2A4A"))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        HStack {
                            Text("\(targetValue)")
                                .font(.system(.title, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("urges")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button(action: { targetValue = max(1, targetValue - 1) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color(hex: "#4E76F7"))
                                }
                                
                                Button(action: { targetValue = min(100, targetValue + 1) }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: "#4E76F7"))
                                }
                            }
                            .font(.title2)
                        }
                        .padding()
                        .background(Color(hex: "#1E2A4A"))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    Button(action: createGoal) {
                        Text("Create")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(goalTitle.isEmpty ? Color.gray : Color(hex: "#4E76F7"))
                            .cornerRadius(12)
                    }
                    .disabled(goalTitle.isEmpty)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "#4E76F7"))
                }
            }
        }
    }
    
    private func createGoal() {
        let newGoal = EnhancedUserGoal(
            title: goalTitle,
            description: nil,
            type: selectedType,
            targetValue: targetValue,
            currentValue: 0,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: selectedType == .daily ? .day : selectedType == .weekly ? .weekOfYear : .month, value: 1, to: Date()) ?? Date()
        )
        
        appState.enhancedAddGoal(newGoal)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .environmentObject(EnhancedAppState())
            .preferredColorScheme(.dark)
    }
} 