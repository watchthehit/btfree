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
    @State private var showingCompletionAnimation = false
    @State private var completedGoalTitle = ""
    @State private var editMode: EditMode = .inactive
    
    // Animation states
    @State private var animateHeader = false
    @State private var animateActiveGoals = false
    @State private var animateSuggestions = false
    @State private var animateCompleted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Active goals section
                        activeGoalsSection
                        
                        // Template goals section
                        if appState.enhancedActiveGoals.count < 3 {
                            suggestionSection()
                        }
                        
                        // Completed goals section
                        if !appState.enhancedCompletedGoals.isEmpty {
                            completedGoalsSection
                        }
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("Goals")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingNewGoalSheet = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(BFDesignColors.accent)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .foregroundColor(BFDesignColors.accent)
                    }
                }
                .environment(\.editMode, $editMode)
                .sheet(isPresented: $showingNewGoalSheet) {
                    EnhancedNewGoalView()
                }
                .background(BFDesignColors.primaryBackground.edgesIgnoringSafeArea(.all))
                .onAppear {
                    startAnimations()
                }
                
                // Goal completion celebration overlay
                if showingCompletionAnimation {
                    goalCompletionCelebration()
                }
            }
        }
    }
    
    // MARK: - Active Goals Section
    
    private var activeGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Goals")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 16)
                .opacity(animateHeader ? 1 : 0)
                .offset(y: animateHeader ? 0 : -10)
            
            if appState.enhancedActiveGoals.isEmpty {
                emptyGoalsView
            } else {
                ForEach(appState.enhancedActiveGoals) { goal in
                    GoalCard(goal: goal, onCompletion: { goalTitle in
                        withAnimation {
                            completedGoalTitle = goalTitle
                            showingCompletionAnimation = true
                        }
                        // Hide animation after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showingCompletionAnimation = false
                            }
                        }
                    })
                    .padding(.horizontal)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                .opacity(animateActiveGoals ? 1 : 0)
                .offset(y: animateActiveGoals ? 0 : 20)
            }
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Empty Goals View
    
    private var emptyGoalsView: some View {
        VStack(spacing: 20) {
            // Visual element
            ZStack {
                Circle()
                    .fill(BFDesignColors.accent.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "target")
                    .font(.system(size: 40))
                    .foregroundColor(BFDesignColors.accent)
            }
            .padding(.bottom, 10)
            
            // Title and description
            VStack(spacing: 12) {
                Text("No active goals yet")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Text("Setting goals helps you stay motivated and track your progress. Start by creating your first goal.")
                    .font(.subheadline)
                    .foregroundColor(BFDesignColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
                    .padding(.horizontal, 20)
            }
            
            // Motivational tips
            VStack(alignment: .leading, spacing: 10) {
                Text("Tips for effective goals:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(BFDesignColors.textPrimary)
                    .padding(.top, 5)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFDesignColors.accent)
                        .font(.caption)
                    
                    Text("Start with a smaller daily goal")
                        .font(.caption)
                        .foregroundColor(BFDesignColors.textSecondary)
                }
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFDesignColors.accent)
                        .font(.caption)
                    
                    Text("Be specific about what you want to achieve")
                        .font(.caption)
                        .foregroundColor(BFDesignColors.textSecondary)
                }
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFDesignColors.accent)
                        .font(.caption)
                    
                    Text("Celebrate each completed goal")
                        .font(.caption)
                        .foregroundColor(BFDesignColors.textSecondary)
                }
            }
            .frame(maxWidth: 280)
            .padding(.vertical, 10)
            
            // Create button
            Button(action: {
                showingNewGoalSheet = true
                HapticManager.shared.playLightFeedback()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create New Goal")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [BFDesignColors.accent, BFDesignColors.accent.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: BFDesignColors.accent.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .accessibilityHint("Tap to create your first goal")
            .padding(.top, 10)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(BFDesignColors.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(BFDesignColors.accent.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 30)
        .opacity(animateActiveGoals ? 1 : 0)
        .offset(y: animateActiveGoals ? 0 : 20)
    }
    
    // MARK: - Completed Goals Section
    
    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 8)
                
            Text("Completed Goals")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 8)
                .opacity(animateHeader ? 1 : 0)
                .offset(y: animateHeader ? 0 : -10)
            
            ForEach(appState.enhancedCompletedGoals) { goal in
                CompletedGoalCard(goal: goal)
                    .padding(.horizontal)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
            .opacity(animateCompleted ? 1 : 0)
            .offset(y: animateCompleted ? 0 : 20)
        }
    }
    
    /// Section with goal suggestions
    @ViewBuilder
    private func suggestionSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Text("Suggested Goals")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 8)
                .opacity(animateHeader ? 1 : 0)
                .offset(y: animateHeader ? 0 : -10)
            
            // Daily goal suggestion
            if !appState.enhancedActiveGoals.contains(where: { $0.title.contains("today") }) {
                suggestionCard(
                    title: "Daily Goal",
                    description: "Handle 5 urges today",
                    duration: "1 day",
                    target: 5,
                    type: .daily,
                    color: BFDesignColors.accent
                )
            }
            
            // Weekly goal suggestion
            if !appState.enhancedActiveGoals.contains(where: { $0.title.contains("week") }) {
                suggestionCard(
                    title: "Weekly Goal",
                    description: "Handle 20 urges this week",
                    duration: "7 days",
                    target: 20,
                    type: .weekly,
                    color: BFDesignColors.secondary
                )
            }
            
            // Monthly goal suggestion
            if !appState.enhancedActiveGoals.contains(where: { $0.title.contains("month") }) {
                suggestionCard(
                    title: "Monthly Goal",
                    description: "Handle 50 urges this month",
                    duration: "30 days",
                    target: 50,
                    type: .monthly,
                    color: BFDesignColors.streakFlame
                )
            }
        }
        .padding(.bottom, 24)
        .opacity(animateSuggestions ? 1 : 0)
        .offset(y: animateSuggestions ? 0 : 20)
    }
    
    /// Card for goal suggestions
    private func suggestionCard(title: String, description: String, duration: String, target: Int, type: EnhancedGoalType, color: Color) -> some View {
        Button(action: {
            let newGoal = EnhancedUserGoal(
                title: title,
                description: description,
                type: type,
                targetValue: target,
                currentValue: 0,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: type == .daily ? 1 : type == .weekly ? 7 : 30, to: Date()) ?? Date()
            )
            
            withAnimation(.spring()) {
                appState.enhancedAddGoal(newGoal)
            }
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(BFDesignColors.textPrimary)
                    
                    Spacer()
                    
                    // Goal type icon
                    Image(systemName: type == .daily ? "sun.max.fill" : type == .weekly ? "calendar.badge.clock" : "calendar")
                        .foregroundColor(color)
                }
                
                Text(description)
                    .foregroundColor(BFDesignColors.textSecondary)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(duration)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(color)
                        .font(.system(size: 22))
                }
                .font(.caption)
                .foregroundColor(BFDesignColors.textSecondary)
            }
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
    
    /// Celebration overlay for completed goals
    private func goalCompletionCelebration() -> some View {
        ZStack {
            // Darkened background
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showingCompletionAnimation = false
                    }
                }
            
            // Confetti effect (simple implementation)
            GeometryReader { geo in
                ForEach(0..<30) { i in
                    Circle()
                        .fill(confettiColor(for: i))
                        .frame(width: CGFloat.random(in: 5...12))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height/2)
                        )
                        .offset(y: animateConfetti(for: i))
                        .opacity(animateConfetti(for: i) > 400 ? 0 : 1)
                }
            }
            
            // Celebration content
            VStack(spacing: 20) {
                // Trophy icon
                ZStack {
                    Circle()
                        .fill(BFDesignColors.accent.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundColor(BFDesignColors.accent)
                        .shadow(color: BFDesignColors.accent.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 10)
                
                Text("🎉 Goal Completed! 🎉")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Text(completedGoalTitle)
                    .font(.headline)
                    .foregroundColor(BFDesignColors.accent)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                // Motivational message
                Text("Great job staying on track!\nKeep up the momentum!")
                    .foregroundColor(BFDesignColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                // Stats
                HStack(spacing: 25) {
                    VStack {
                        Text("\(appState.urgesHandled)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(BFDesignColors.accent)
                        Text("Total Urges")
                            .font(.caption)
                            .foregroundColor(BFDesignColors.textSecondary)
                    }
                    
                    VStack {
                        Text("\(appState.streakDays)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(BFDesignColors.accent)
                        Text("Day Streak")
                            .font(.caption)
                            .foregroundColor(BFDesignColors.textSecondary)
                    }
                    
                    VStack {
                        Text("\(appState.enhancedCompletedGoals.count)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(BFDesignColors.accent)
                        Text("Goals Done")
                            .font(.caption)
                            .foregroundColor(BFDesignColors.textSecondary)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                Button(action: {
                    withAnimation {
                        showingCompletionAnimation = false
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 16)
                        .background(BFDesignColors.accent)
                        .cornerRadius(12)
                        .shadow(color: BFDesignColors.accent.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(BFDesignColors.cardBackground.opacity(0.97))
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(BFDesignColors.accent.opacity(0.3), lineWidth: 2)
            )
            .transition(.scale.combined(with: .opacity))
        }
        .onAppear {
            HapticManager.shared.playSuccessFeedback()
            // Start the confetti animation on appear
            withAnimation(Animation.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
                animatingConfetti = true
            }
        }
    }
    
    // Helper for confetti animation
    @State private var animatingConfetti = false
    
    private func confettiColor(for index: Int) -> Color {
        let colors: [Color] = [
            BFDesignColors.accent,
            BFDesignColors.secondary,
            BFDesignColors.mindfulness,
            BFDesignColors.streakFlame,
            .yellow,
            .green
        ]
        return colors[index % colors.count]
    }
    
    private func animateConfetti(for index: Int) -> CGFloat {
        let speed = Double.random(in: 0.2...1.0)
        return animatingConfetti ? 800 * speed : -50
    }
    
    // Start animations in sequence
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.5)) {
            animateHeader = true
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
            animateActiveGoals = true
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
            animateSuggestions = true
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
            animateCompleted = true
        }
    }
}

/// Card view for an active goal
struct GoalCard: View {
    let goal: EnhancedUserGoal
    let onCompletion: (String) -> Void
    @EnvironmentObject var appState: EnhancedAppState
    @State private var showingCompletionAlert = false
    @State private var isPressed = false
    
    var body: some View {
        let progress = appState.enhancedGetProgressForGoal(goal: goal)
        let current = appState.enhancedGetCurrentValueForGoal(goal: goal)
        
        return VStack(alignment: .leading, spacing: 15) {
            HStack {
                HStack(spacing: 8) {
                    // Goal type indicator dot
                    Circle()
                        .fill(typeColor())
                        .frame(width: 10, height: 10)
                    
                    Text(goal.title)
                        .font(.headline)
                        .foregroundColor(BFDesignColors.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Progress indicator
                HStack(spacing: 5) {
                    Text("\(current)/\(goal.targetValue)")
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.textPrimary)
                    
                    Text("urges")
                        .font(.caption)
                        .foregroundColor(BFDesignColors.textSecondary)
                }
            }
            
            if let description = goal.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(BFDesignColors.textSecondary)
                    .lineLimit(2)
                    .padding(.top, -5)
            }
            
            // Progress bar with more visual feedback
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 10)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [progressColor(progress: progress), progressColor(progress: progress).opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: max(5, CGFloat(progress) * UIScreen.main.bounds.width - 50), height: 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
                .accessibilityValue(Text("\(Int(progress * 100))% complete"))
                
                // Progress percentage
                if current > 0 {
                    Text("\(Int(progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(progressColor(progress: progress))
                        .padding(.top, -4)
                }
            }
            
            HStack {
                // Days remaining
                let daysRemaining = appState.enhancedGetDaysRemainingForGoal(goal: goal)
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(daysRemaining == 0 ? "Today" : "\(daysRemaining) days")
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.textPrimary)
                }
                
                Spacer()
                
                // Complete button
                if progress >= 1.0 {
                    Button(action: {
                        showingCompletionAlert = true
                        HapticManager.shared.playSuccessFeedback()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Complete")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(BFDesignColors.accent)
                        .cornerRadius(16)
                        .shadow(color: BFDesignColors.accent.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .alert("Complete Goal", isPresented: $showingCompletionAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Complete") {
                            withAnimation {
                                appState.enhancedCompleteGoal(goal: goal)
                                onCompletion(goal.title)
                                HapticManager.shared.playSuccessFeedback()
                            }
                        }
                    } message: {
                        Text("Mark this goal as completed?")
                    }
                    .accessibilityHint("Tap to mark this goal as completed")
                }
            }
        }
        .padding()
        .background(BFDesignColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(goalBorderColor(), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isPressed = false
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Goal: \(goal.title)")
    }
    
    /// Color for the progress bar based on progress
    private func progressColor(progress: Double) -> Color {
        if progress >= 1.0 {
            return BFDesignColors.accent
        } else if progress >= 0.7 {
            return BFDesignColors.secondary
        } else if progress >= 0.4 {
            return BFDesignColors.mindfulness
        } else {
            return BFDesignColors.streakFlame
        }
    }
    
    /// Color for the goal type indicator
    private func typeColor() -> Color {
        switch goal.type {
        case .daily:
            return BFDesignColors.accent
        case .weekly:
            return BFDesignColors.secondary
        case .monthly:
            return BFDesignColors.streakFlame
        }
    }
    
    /// Border color based on goal type
    private func goalBorderColor() -> Color {
        switch goal.type {
        case .daily:
            return BFDesignColors.accent.opacity(0.2)
        case .weekly:
            return BFDesignColors.secondary.opacity(0.2)
        case .monthly:
            return BFDesignColors.streakFlame.opacity(0.2)
        }
    }
}

/// Card view for a completed goal
struct CompletedGoalCard: View {
    let goal: EnhancedUserGoal
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Spacer()
                
                // Completion indicator with date
                HStack(spacing: 5) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFDesignColors.accent)
                    
                    if let completedAt = goal.completedAt {
                        Text(completedAt, style: .date)
                            .font(.subheadline)
                            .foregroundColor(BFDesignColors.textSecondary)
                    }
                }
            }
            
            // Target value with more details
            HStack(spacing: 12) {
                HStack(spacing: 5) {
                    Image(systemName: "target")
                    Text("\(goal.targetValue) urges")
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.textPrimary)
                }
                
                if let completedAt = goal.completedAt, let _ = Calendar.current.date(byAdding: .day, value: -getDuration(for: goal.type), to: completedAt) {
                    Divider()
                        .frame(height: 16)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "calendar")
                        Text("\(getDurationText(for: goal.type))")
                            .font(.caption)
                            .foregroundColor(BFDesignColors.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(BFDesignColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(completedGoalBorderColor(), lineWidth: 1)
        )
        .opacity(0.9)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isPressed = false
                    }
                }
            }
        }
    }
    
    /// Border color for completed goals
    private func completedGoalBorderColor() -> Color {
        switch goal.type {
        case .daily:
            return BFDesignColors.accent.opacity(0.2)
        case .weekly:
            return BFDesignColors.secondary.opacity(0.2)
        case .monthly:
            return BFDesignColors.streakFlame.opacity(0.2)
        }
    }
    
    /// Get duration in days based on goal type
    private func getDuration(for type: EnhancedGoalType) -> Int {
        switch type {
        case .daily:
            return 1
        case .weekly:
            return 7
        case .monthly:
            return 30
        }
    }
    
    /// Get duration text based on goal type
    private func getDurationText(for type: EnhancedGoalType) -> String {
        switch type {
        case .daily:
            return "1 day"
        case .weekly:
            return "7 days"
        case .monthly:
            return "30 days"
        }
    }
}

/**
 * EnhancedNewGoalView
 * 
 * A modal view for creating new goals with various configuration options.
 * Allows users to set:
 * - Goal title and description
 * - Goal type (daily, weekly, monthly)
 * - Target value of urges to handle
 * - Target completion date
 * 
 * The view automatically adjusts target dates based on the selected goal type
 * and integrates with the EnhancedAppState to save new goals.
 */
struct EnhancedNewGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: EnhancedAppState
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title
        case description
    }
    
    @State private var goalTitle = ""
    @State private var goalDescription = ""
    @State private var selectedType: EnhancedGoalType = .weekly
    @State private var targetValue = 20
    @State private var targetDate = Date().addingTimeInterval(86400 * 7) // One week from now
    @State private var showingDatePicker = false
    
    // Form validation 
    private var isTitleValid: Bool {
        !goalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var targetValueText: String {
        switch selectedType {
        case .daily:
            return targetValue == 1 ? "1 urge today" : "\(targetValue) urges today"
        case .weekly:
            return "\(targetValue) urges this week"
        case .monthly:
            return "\(targetValue) urges this month"
        }
    }
    
    private var formattedTargetDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: targetDate)
    }
    
    var body: some View {
        NavigationView {
            UIComponents.ScreenBackground {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title and description section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Goal Details")
                                .font(.headline)
                                .foregroundColor(BFDesignColors.textPrimary)
                            
                            // Title field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.subheadline)
                                    .foregroundColor(BFDesignColors.textSecondary)
                                
                                TextField("Goal Title", text: $goalTitle)
                                    .padding()
                                    .background(BFDesignColors.inputBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isTitleValid ? Color.gray.opacity(0.2) : Color.red.opacity(0.5), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .title)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .description
                                    }
                                
                                if !isTitleValid && focusedField != .title {
                                    Text("Please enter a goal title")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Description field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description (Optional)")
                                    .font(.subheadline)
                                    .foregroundColor(BFDesignColors.textSecondary)
                                
                                TextField("Description", text: $goalDescription, axis: .vertical)
                                    .lineLimit(3)
                                    .padding()
                                    .background(BFDesignColors.inputBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .description)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        focusedField = nil
                                    }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Goal type selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Goal Type")
                                .font(.headline)
                                .foregroundColor(BFDesignColors.textPrimary)
                            
                            HStack(spacing: 8) {
                                ForEach(EnhancedGoalType.allCases, id: \.self) { type in
                                    Button(action: {
                                        selectedType = type
                                        updateTargetDate()
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: typeIcon(for: type))
                                                .font(.system(size: 20))
                                            
                                            Text(type.displayName)
                                                .font(.subheadline)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(selectedType == type ? typeColor(for: type).opacity(0.15) : Color.gray.opacity(0.05))
                                        .foregroundColor(selectedType == type ? typeColor(for: type) : BFDesignColors.textSecondary)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedType == type ? typeColor(for: type).opacity(0.5) : Color.clear, lineWidth: 2)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Target value slider
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Target")
                                .font(.headline)
                                .foregroundColor(BFDesignColors.textPrimary)
                            
                            Text(targetValueText)
                                .font(.title3)
                                .foregroundColor(typeColor(for: selectedType))
                                .padding(.bottom, 4)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("1")
                                        .font(.caption)
                                        .foregroundColor(BFDesignColors.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text("50")
                                        .font(.caption)
                                        .foregroundColor(BFDesignColors.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text("100")
                                        .font(.caption)
                                        .foregroundColor(BFDesignColors.textSecondary)
                                }
                                .padding(.horizontal, 4)
                                
                                Slider(value: .init(get: {
                                    Double(targetValue)
                                }, set: { newValue in
                                    targetValue = Int(newValue)
                                    HapticManager.shared.playLightFeedback()
                                }), in: 1...100, step: 1)
                                .accentColor(typeColor(for: selectedType))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Target date
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Target Date")
                                .font(.headline)
                                .foregroundColor(BFDesignColors.textPrimary)
                            
                            Button(action: {
                                withAnimation {
                                    showingDatePicker.toggle()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(typeColor(for: selectedType))
                                    
                                    Text(formattedTargetDate)
                                        .foregroundColor(BFDesignColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: showingDatePicker ? "chevron.up" : "chevron.down")
                                        .foregroundColor(BFDesignColors.textSecondary)
                                        .font(.footnote)
                                }
                                .padding()
                                .background(BFDesignColors.inputBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            if showingDatePicker {
                                DatePicker("", selection: $targetDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                                    .background(BFDesignColors.inputBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                    .transition(.opacity)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Create button
                        Button(action: {
                            createGoal()
                        }) {
                            Text("Create Goal")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isTitleValid ? BFDesignColors.accent : BFDesignColors.accent.opacity(0.3))
                                .cornerRadius(16)
                                .shadow(color: isTitleValid ? BFDesignColors.accent.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 3)
                        }
                        .disabled(!isTitleValid)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 20)
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.immediately)
            }
            .navigationTitle("New Goal")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
    
    private func typeIcon(for type: EnhancedGoalType) -> String {
        switch type {
        case .daily:
            return "sun.max.fill"
        case .weekly:
            return "calendar.badge.clock"
        case .monthly:
            return "calendar"
        }
    }
    
    private func typeColor(for type: EnhancedGoalType) -> Color {
        switch type {
        case .daily:
            return BFDesignColors.accent
        case .weekly:
            return BFDesignColors.secondary
        case .monthly:
            return BFDesignColors.streakFlame
        }
    }
    
    private func updateTargetDate() {
        let calendar = Calendar.current
        
        switch selectedType {
        case .daily:
            targetDate = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            targetValue = min(targetValue, 15) // Adjust for realistic daily targets
        case .weekly:
            targetDate = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
            targetValue = max(targetValue, 10) // Ensure weekly targets are appropriate
        case .monthly:
            targetDate = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
            targetValue = max(targetValue, 20) // Ensure monthly targets are appropriate
        }
    }
    
    private func createGoal() {
        guard isTitleValid else { return }
        
        let newGoal = EnhancedUserGoal(
            title: goalTitle,
            description: goalDescription.isEmpty ? nil : goalDescription,
            type: selectedType,
            targetValue: targetValue,
            currentValue: 0,
            startDate: Date(),
            endDate: targetDate
        )
        
        appState.enhancedAddGoal(newGoal)
        HapticManager.shared.playSuccessFeedback()
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .environmentObject(EnhancedAppState())
    }
} 