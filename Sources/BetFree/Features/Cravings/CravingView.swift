import SwiftUI
import Charts

public struct CravingView: View {
    @StateObject private var manager = CravingManager()
    @State private var showingAddSheet = false
    @State private var selectedCraving: Craving?
    
    // Form state
    @State private var intensity = 3
    @State private var trigger = ""
    @State private var location = ""
    @State private var emotion = ""
    @State private var duration = 300.0 // 5 minutes
    @State private var copingStrategy = ""
    @State private var outcome = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Cards
                    statsGrid
                    
                    // Intensity Chart
                    intensityChart
                        .frame(height: 200)
                    
                    // Recent Cravings
                    recentCravingsList
                }
                .padding()
            }
            .navigationTitle("Cravings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                        BFHaptics.warning()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .semanticMeaning("Add Craving Button")
                    .semanticHint("Double tap to log a new craving")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            addCravingSheet
        }
        .sheet(item: $selectedCraving) { craving in
            cravingDetailSheet(craving)
        }
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            statCard(
                title: "Average Intensity",
                value: String(format: "%.1f", manager.averageIntensity),
                icon: "chart.line.uptrend.xyaxis",
                color: intensityColor(manager.averageIntensity)
            )
            
            statCard(
                title: "Trend",
                value: trendText(manager.getCravingTrend()),
                icon: trendIcon(manager.getCravingTrend()),
                color: trendColor(manager.getCravingTrend())
            )
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        BFCard(style: .default) {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(BFDesignSystem.Typography.labelMedium)
                }
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(color)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .semanticMeaning("\(title) Card")
        .semanticValue(value)
        .semanticHint("Shows \(title.lowercased())")
    }
    
    private var intensityChart: some View {
        BFCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cravings by Time")
                    .font(BFDesignSystem.Typography.titleMedium)
                
                Chart(manager.cravingsByTime, id: \.hour) { hourData in
                    BarMark(
                        x: .value("Hour", hourData.hour),
                        y: .value("Count", hourData.count)
                    )
                    .foregroundStyle(BFDesignSystem.Colors.primary)
                }
            }
            .padding()
        }
        .semanticMeaning("Cravings by Time Chart")
        .semanticValue("\(manager.cravingsByTime.reduce(0) { $0 + $1.count }) cravings recorded")
        .semanticHint("Shows when cravings typically occur")
    }
    
    private var recentCravingsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Cravings")
                .font(BFDesignSystem.Typography.titleMedium)
            
            ForEach(manager.getRecentCravings()) { craving in
                Button {
                    selectedCraving = craving
                    BFHaptics.warning()
                } label: {
                    CravingRow(craving: craving)
                }
            }
        }
    }
    
    private var addCravingSheet: some View {
        NavigationView {
            Form {
                Section("Intensity") {
                    Slider(value: .init(
                        get: { Double(intensity) },
                        set: { intensity = Int($0) }
                    ), in: 1...5, step: 1) {
                        Text("Intensity")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("5")
                    }
                    .semanticValue("\(intensity) out of 5")
                }
                
                Section("Details") {
                    TextField("What triggered it?", text: $trigger)
                        .semanticHint("Enter what caused the craving")
                    
                    TextField("Where were you?", text: $location)
                        .semanticHint("Enter your location")
                    
                    Picker("How did you feel?", selection: $emotion) {
                        Text("Select emotion").tag("")
                        ForEach(CravingManager.commonEmotions, id: \.self) { emotion in
                            Text(emotion).tag(emotion)
                        }
                    }
                }
                
                Section("Duration") {
                    Slider(value: $duration, in: 60...3600, step: 60) {
                        Text("Duration")
                    } minimumValueLabel: {
                        Text("1m")
                    } maximumValueLabel: {
                        Text("1h")
                    }
                    .semanticValue("\(manager.formatDuration(duration))")
                }
                
                Section("Response") {
                    Picker("Coping strategy used", selection: $copingStrategy) {
                        Text("Select strategy").tag("")
                        ForEach(CravingManager.copingStrategies, id: \.self) { strategy in
                            Text(strategy).tag(strategy)
                        }
                    }
                    
                    TextField("Outcome", text: $outcome)
                        .semanticHint("Enter what happened")
                }
                
                Section {
                    Button("Log Craving") {
                        let craving = Craving(
                            intensity: intensity,
                            trigger: trigger,
                            location: location.isEmpty ? nil : location,
                            emotion: emotion.isEmpty ? nil : emotion,
                            duration: duration,
                            copingStrategy: copingStrategy.isEmpty ? nil : copingStrategy,
                            outcome: outcome.isEmpty ? nil : outcome
                        )
                        manager.add(craving)
                        showingAddSheet = false
                        resetForm()
                    }
                    .disabled(trigger.isEmpty)
                }
            }
            .navigationTitle("Log Craving")
            .navigationBarItems(trailing: Button("Cancel") {
                showingAddSheet = false
                BFHaptics.error()
            })
        }
    }
    
    private func cravingDetailSheet(_ craving: Craving) -> some View {
        NavigationView {
            List {
                Section("Details") {
                    LabeledContent("Intensity", value: "\(craving.intensity)/5")
                    LabeledContent("Trigger", value: craving.trigger)
                    if let location = craving.location {
                        LabeledContent("Location", value: location)
                    }
                    if let emotion = craving.emotion {
                        LabeledContent("Emotion", value: emotion)
                    }
                    LabeledContent("Duration", value: manager.formatDuration(craving.duration))
                }
                
                if let strategy = craving.copingStrategy {
                    Section("Response") {
                        LabeledContent("Strategy", value: strategy)
                        if let outcome = craving.outcome {
                            LabeledContent("Outcome", value: outcome)
                        }
                    }
                }
            }
            .navigationTitle("Craving Details")
            .navigationBarItems(trailing: Button("Done") {
                selectedCraving = nil
            })
        }
    }
    
    private func resetForm() {
        intensity = 3
        trigger = ""
        location = ""
        emotion = ""
        duration = 300
        copingStrategy = ""
        outcome = ""
    }
    
    private func intensityColor(_ value: Double) -> Color {
        switch value {
        case ..<2:
            return BFDesignSystem.Colors.success
        case ..<4:
            return BFDesignSystem.Colors.warning
        default:
            return BFDesignSystem.Colors.error
        }
    }
    
    private func trendText(_ value: Double) -> String {
        switch value {
        case ..<(-0.5):
            return "Decreasing"
        case ...0.5:
            return "Stable"
        default:
            return "Increasing"
        }
    }
    
    private func trendIcon(_ value: Double) -> String {
        switch value {
        case ..<(-0.5):
            return "arrow.down.circle.fill"
        case ...0.5:
            return "equal.circle.fill"
        default:
            return "arrow.up.circle.fill"
        }
    }
    
    private func trendColor(_ value: Double) -> Color {
        switch value {
        case ..<(-0.5):
            return BFDesignSystem.Colors.success
        case ...0.5:
            return BFDesignSystem.Colors.primary
        default:
            return BFDesignSystem.Colors.error
        }
    }
}

private struct CravingRow: View {
    let craving: Craving
    
    var body: some View {
        BFCard(style: .default) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(craving.trigger)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    
                    Text(craving.timestamp, style: .relative)
                        .font(BFDesignSystem.Typography.labelMedium)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                Text("\(craving.intensity)")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(intensityColor(Double(craving.intensity)))
            }
            .padding()
        }
        .semanticMeaning("Craving Entry")
        .semanticValue("Intensity \(craving.intensity) out of 5, triggered by \(craving.trigger)")
        .semanticHint("Double tap to view details")
    }
    
    private func intensityColor(_ value: Double) -> Color {
        switch value {
        case ..<2:
            return BFDesignSystem.Colors.success
        case ..<4:
            return BFDesignSystem.Colors.warning
        default:
            return BFDesignSystem.Colors.error
        }
    }
}

#Preview {
    CravingView()
}
