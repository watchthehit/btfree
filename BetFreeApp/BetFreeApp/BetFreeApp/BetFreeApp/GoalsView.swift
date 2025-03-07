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
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 10)
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
    }
    
    // MARK: - Empty Goals View
    
    private var emptyGoalsView: some View {
        VStack(spacing: 15) {
            Image(systemName: "target")
                .font(.system(size: 40))
                .foregroundColor(BFDesignColors.textSecondary)
            
            Text("No active goals")
                .font(.headline)
                .foregroundColor(BFDesignColors.textPrimary)
            
            Text("Add your first goal to start tracking progress")
                .font(.subheadline)
                .foregroundColor(BFDesignColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button(action: {
                showingNewGoalSheet = true
            }) {
                Text("Create New Goal")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(BFDesignColors.accent)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .opacity(animateActiveGoals ? 1 : 0)
        .offset(y: animateActiveGoals ? 0 : 20)
    }
    
    // MARK: - Completed Goals Section
    
    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Goals")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 10)
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
            Text("Suggested Goals")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(BFDesignColors.textPrimary)
                .padding(.horizontal)
                .padding(.top, 10)
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
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFDesignColors.accent)
                
                Text("🎉 Goal Completed! 🎉")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Text(completedGoalTitle)
                    .font(.headline)
                    .foregroundColor(BFDesignColors.accent)
                
                Text("Great job staying on track!")
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Button(action: {
                    withAnimation {
                        showingCompletionAnimation = false
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(BFDesignColors.accent)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(BFDesignColors.cardBackground.opacity(0.95))
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale.combined(with: .opacity))
        }
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
                Text(goal.title)
                    .font(.headline)
                    .foregroundColor(BFDesignColors.textPrimary)
                
                Spacer()
                
                // Progress indicator
                HStack(spacing: 5) {
                    Text("\(current)/\(goal.targetValue) urges")
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.textPrimary)
                }
            }
            
            // Progress bar with more visual feedback
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [progressColor(progress: progress), progressColor(progress: progress).opacity(0.7)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: max(5, CGFloat(progress) * UIScreen.main.bounds.width - 50), height: 8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
            }
            
            HStack {
                // Days remaining
                let daysRemaining = appState.enhancedGetDaysRemainingForGoal(goal: goal)
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                    Text(daysRemaining == 0 ? "Today" : "\(daysRemaining) days")
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.textPrimary)
                }
                
                Spacer()
                
                // More detail on progress
                if current > 0 {
                    Text("\(Int(progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(BFDesignColors.textSecondary)
                }
                
                // Complete button
                if progress >= 1.0 {
                    Button(action: {
                        showingCompletionAlert = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Complete")
                        }
                        .font(.subheadline)
                        .foregroundColor(BFDesignColors.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(BFDesignColors.accent.opacity(0.1))
                        .cornerRadius(16)
                    }
                    .alert("Complete Goal", isPresented: $showingCompletionAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Complete") {
                            withAnimation {
                                appState.enhancedCompleteGoal(goal: goal)
                                onCompletion(goal.title)
                            }
                        }
                    } message: {
                        Text("Mark this goal as completed?")
                    }
                }
            }
        }
        .padding()
        .background(BFDesignColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(goalBorderColor(), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
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
    
    /// Border color based on goal type
    private func goalBorderColor() -> Color {
        switch goal.type {
        case .daily:
            return BFDesignColors.accent.opacity(0.3)
        case .weekly:
            return BFDesignColors.secondary.opacity(0.3)
        case .monthly:
            return BFDesignColors.streakFlame.opacity(0.3)
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
    
    @State private var goalTitle = ""
    @State private var goalDescription = ""
    @State private var selectedType: EnhancedGoalType = .weekly
    @State private var targetValue = 10
    @State private var targetDate = Date().addingTimeInterval(86400 * 7) // One week from now
    
    var body: some View {
        NavigationView {
            UIComponents.ScreenBackground {
                Form {
                    Section {
                        TextField("Goal Title", text: $goalTitle)
                            .padding(.vertical, 4)
                        
                        TextField("Description (Optional)", text: $goalDescription)
                            .padding(.vertical, 4)
                        
                        Picker("Goal Type", selection: $selectedType) {
                            Text("Daily").tag(EnhancedGoalType.daily)
                            Text("Weekly").tag(EnhancedGoalType.weekly)
                            Text("Monthly").tag(EnhancedGoalType.monthly)
                        }
                        .onChange(of: selectedType) { oldValue, newValue in
                            // Update target date based on goal type
                            updateTargetDate()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target: \(targetValue) urges")
                            
                            HStack {
                                Text("1")
                                    .font(.caption)
                                
                                Slider(value: .init(get: {
                                    Double(targetValue)
                                }, set: { newValue in
                                    targetValue = Int(newValue)
                                }), in: 1...100, step: 1)
                                
                                Text("100")
                                    .font(.caption)
                            }
                        }
                        
                        DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                    } header: {
                        Text("Goal Details")
                    }
                    
                    Section {
                        Button(action: {
                            createGoal()
                        }) {
                            Text("Create Goal")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(BFDesignColors.accent)
                        }
                        .disabled(goalTitle.isEmpty)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Goal")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func updateTargetDate() {
        let calendar = Calendar.current
        
        switch selectedType {
        case .daily:
            targetDate = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case .weekly:
            targetDate = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        case .monthly:
            targetDate = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        }
    }
    
    private func createGoal() {
        let newGoal = EnhancedUserGoal(
            title: goalTitle,
            description: goalDescription,
            type: selectedType,
            targetValue: targetValue,
            currentValue: 0,
            startDate: Date(),
            endDate: targetDate
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
    }
} 