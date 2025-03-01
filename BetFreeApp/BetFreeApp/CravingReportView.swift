import SwiftUI

struct CravingReportView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isShowingNewReport = false
    @State private var filteredReports: [CravingReport] = []
    @State private var selectedTimeframe: TimeframeFilter = .all
    
    enum TimeframeFilter: String, CaseIterable, Identifiable {
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        case all = "All Time"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with statistics
                VStack(spacing: 24) {
                    HStack(spacing: 20) {
                        StatCard(
                            title: "Total Reports",
                            value: "\(appState.cravingReports.count)",
                            icon: "doc.text.fill",
                            color: BFColors.primary
                        )
                        
                        StatCard(
                            title: "Successfully Resisted",
                            value: "\(appState.cravingReports.filter { !$0.didGiveIn }.count)",
                            icon: "hand.raised.fill",
                            color: BFColors.success
                        )
                    }
                    
                    // Filter
                    HStack {
                        Text("Show:")
                            .foregroundColor(BFColors.textSecondary)
                        
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(TimeframeFilter.allCases) { timeframe in
                                Text(timeframe.rawValue).tag(timeframe)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedTimeframe) { _ in
                            filterReports()
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding()
                .background(BFColors.cardBackground)
                
                // Reports list
                if filteredReports.isEmpty {
                    emptyStateView
                } else {
                    reportsList
                }
                
                // Add report button
                Button(action: {
                    isShowingNewReport = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Report a Craving")
                    }
                    .frame(maxWidth: .infinity)
                }
                .primaryButtonStyle()
                .padding()
                .background(BFColors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: -2)
            }
            .sheet(isPresented: $isShowingNewReport) {
                NavigationView {
                    CravingReportFormView(isPresented: $isShowingNewReport)
                        .navigationTitle("Report a Craving")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isShowingNewReport = false
                                }
                            }
                        }
                }
            }
            .navigationTitle("Craving Reports")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isShowingNewReport = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                filterReports()
            }
        }
    }
    
    private var emptyStateView: some View {
        BFEmptyStateView(
            icon: "doc.text",
            title: "No Reports Yet",
            message: "When you experience a gambling urge, report it here to track your patterns and build awareness.",
            buttonText: "Report a Craving",
            action: {
                isShowingNewReport = true
            }
        )
        .frame(maxHeight: .infinity)
    }
    
    private var reportsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredReports) { report in
                    CravingReportCard(report: report)
                }
            }
            .padding()
        }
    }
    
    private func filterReports() {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeframe {
        case .today:
            filteredReports = appState.cravingReports.filter {
                calendar.isDateInToday($0.date)
            }
        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            filteredReports = appState.cravingReports.filter {
                $0.date >= startOfWeek
            }
        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            filteredReports = appState.cravingReports.filter {
                $0.date >= startOfMonth
            }
        case .all:
            filteredReports = appState.cravingReports
        }
        
        // Sort by most recent first
        filteredReports.sort { $0.date > $1.date }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .smallStyle()
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CravingReportCard: View {
    var report: CravingReport
    
    var body: some View {
        BFCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(report.date.formatted(date: .abbreviated, time: .shortened))
                            .smallBoldStyle()
                            .foregroundColor(BFColors.textSecondary)
                        
                        Text(report.trigger)
                            .headlineStyle()
                            .foregroundColor(BFColors.textPrimary)
                    }
                    
                    Spacer()
                    
                    // Outcome badge
                    BFBadge(
                        text: report.didGiveIn ? "Gave In" : "Resisted",
                        color: report.didGiveIn ? BFColors.error : BFColors.success
                    )
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    // Intensity meter
                    VStack(spacing: 4) {
                        Text("Intensity")
                            .smallStyle()
                            .foregroundColor(BFColors.textSecondary)
                        
                        HStack(spacing: 4) {
                            ForEach(1...10, id: \.self) { level in
                                Rectangle()
                                    .fill(level <= report.intensity ? BFColors.intensityColor(for: report.intensity) : BFColors.divider)
                                    .frame(height: 16)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .cornerRadius(4)
                    }
                }
                
                if let notes = report.notes, !notes.isEmpty {
                    Text(notes)
                        .bodyStyle()
                        .foregroundColor(BFColors.textSecondary)
                        .padding(.top, 4)
                }
                
                HStack {
                    if let location = report.location, !location.isEmpty {
                        Label(location, systemImage: "location.fill")
                            .smallStyle()
                            .foregroundColor(BFColors.textTertiary)
                    }
                    
                    Spacer()
                    
                    if let emotional = report.emotionalState, !emotional.isEmpty {
                        Label(emotional, systemImage: "heart.fill")
                            .smallStyle()
                            .foregroundColor(BFColors.textTertiary)
                    }
                }
            }
        }
    }
}

struct CravingReportFormView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var isPresented: Bool
    
    @State private var intensity: Int = 5
    @State private var trigger: String = ""
    @State private var didGiveIn: Bool = false
    @State private var notes: String = ""
    @State private var location: String = ""
    @State private var emotionalState: String = ""
    @State private var date: Date = Date()
    
    @State private var commonTriggers: [String] = []
    @State private var isShowingTriggerPicker = false
    
    var body: some View {
        Form {
            Section(header: Text("When did it happen?")) {
                DatePicker("Date and Time", selection: $date)
            }
            
            Section(header: Text("What triggered your urge?")) {
                TextField("Trigger", text: $trigger)
                
                Button(action: {
                    isShowingTriggerPicker = true
                }) {
                    HStack {
                        Text("Select from common triggers")
                            .foregroundColor(BFColors.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(BFColors.textTertiary)
                    }
                }
                .sheet(isPresented: $isShowingTriggerPicker) {
                    TriggerPickerView(
                        selectedTrigger: $trigger,
                        userTriggers: appState.userTriggers,
                        isPresented: $isShowingTriggerPicker
                    )
                }
            }
            
            Section(header: Text("How intense was the urge?")) {
                VStack(spacing: 12) {
                    // Intensity level indicator
                    HStack {
                        Text("Mild")
                            .smallStyle()
                            .foregroundColor(BFColors.textSecondary)
                        
                        Spacer()
                        
                        Text("\(intensity)")
                            .bodyBoldStyle()
                            .foregroundColor(BFColors.intensityColor(for: intensity))
                        
                        Spacer()
                        
                        Text("Severe")
                            .smallStyle()
                            .foregroundColor(BFColors.textSecondary)
                    }
                    
                    // Slider
                    Slider(value: Binding(
                        get: { Double(intensity) },
                        set: { intensity = Int($0) }
                    ), in: 1...10, step: 1)
                    .tint(BFColors.intensityColor(for: intensity))
                    
                    // Visual intensity meter
                    HStack(spacing: 2) {
                        ForEach(1...10, id: \.self) { level in
                            Rectangle()
                                .fill(level <= intensity ? BFColors.intensityColor(for: intensity) : BFColors.divider.opacity(0.3))
                                .frame(height: 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .cornerRadius(6)
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("Did you give in to the urge?")) {
                Toggle("I gambled", isOn: $didGiveIn)
                    .tint(BFColors.primary)
            }
            
            Section(header: Text("Additional information (optional)")) {
                TextField("Location", text: $location)
                
                TextField("How were you feeling?", text: $emotionalState)
                
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(4...6)
            }
            
            Section {
                Button(action: {
                    saveReport()
                }) {
                    Text("Save Report")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(trigger.isEmpty)
            }
        }
    }
    
    private func saveReport() {
        let report = CravingReport(
            date: date,
            intensity: intensity,
            trigger: trigger,
            didGiveIn: didGiveIn,
            notes: notes.isEmpty ? nil : notes,
            location: location.isEmpty ? nil : location,
            emotionalState: emotionalState.isEmpty ? nil : emotionalState
        )
        
        appState.addCravingReport(report)
        
        // Add the trigger to user triggers if it's not already there
        if !trigger.isEmpty && !appState.userTriggers.contains(trigger) {
            appState.addTrigger(trigger)
        }
        
        isPresented = false
    }
}

struct TriggerPickerView: View {
    @Binding var selectedTrigger: String
    var userTriggers: [String]
    @Binding var isPresented: Bool
    
    // Common triggers if user hasn't added their own
    private let defaultTriggers = [
        "Watching sports",
        "Financial stress",
        "Boredom",
        "Advertisements",
        "Social pressure",
        "Feeling down",
        "Celebrating something",
        "Payday",
        "Alcohol consumption"
    ]
    
    var triggers: [String] {
        userTriggers.isEmpty ? defaultTriggers : userTriggers
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(triggers, id: \.self) { trigger in
                        Button(action: {
                            selectedTrigger = trigger
                            isPresented = false
                        }) {
                            HStack {
                                Text(trigger)
                                    .foregroundColor(BFColors.textPrimary)
                                
                                Spacer()
                                
                                if trigger == selectedTrigger {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(BFColors.primary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select a Trigger")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct CravingReportView_Previews: PreviewProvider {
    static var previews: some View {
        CravingReportView()
            .environmentObject(AppState())
    }
} 