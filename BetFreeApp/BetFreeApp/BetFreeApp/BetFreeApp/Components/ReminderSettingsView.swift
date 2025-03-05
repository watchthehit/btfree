import SwiftUI

/// A view that allows users to configure reminders for tracking their gambling urges
struct ReminderSettingsView: View {
    @StateObject private var viewModel = ReminderSettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Daily check-in reminder section
                Section(header: Text("Daily Check-In")) {
                    Toggle("Enable Daily Reminder", isOn: $viewModel.isDailyReminderEnabled)
                        .tint(BFColors.accent)
                    
                    if viewModel.isDailyReminderEnabled {
                        DatePicker("Reminder Time", selection: $viewModel.dailyReminderTime, displayedComponents: .hourAndMinute)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Receive a daily reminder to track your urges and progress")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.top, 4)
                    }
                }
                
                // Idle reminder section
                Section(header: Text("Tracking Reminders")) {
                    Toggle("Remind if No Tracking", isOn: $viewModel.isIdleReminderEnabled)
                        .tint(BFColors.accent)
                    
                    if viewModel.isIdleReminderEnabled {
                        Picker("Remind After", selection: $viewModel.idleHours) {
                            ForEach(4...24, id: \.self) { hour in
                                Text(hour == 24 ? "1 day" : "\(hour) hours")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Get a reminder if you haven't tracked any urges after the specified time period")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.top, 4)
                    }
                }
                
                // High-risk time reminders
                Section(header: Text("High-Risk Time Alerts")) {
                    Toggle("Weekend Evening Alerts", isOn: $viewModel.isWeekendAlertEnabled)
                        .tint(BFColors.accent)
                    
                    Toggle("Payday Alerts", isOn: $viewModel.isPaydayAlertEnabled)
                        .tint(BFColors.accent)
                    
                    if viewModel.isPaydayAlertEnabled {
                        HStack {
                            Text("Payday Date")
                            Spacer()
                            Text(viewModel.paydayDateFormatted)
                                .foregroundColor(BFColors.textSecondary)
                        }
                        .onTapGesture {
                            viewModel.isShowingPaydayPicker = true
                        }
                    }
                    
                    Toggle("Custom High-Risk Times", isOn: $viewModel.isCustomRiskTimeEnabled)
                        .tint(BFColors.accent)
                    
                    if viewModel.isCustomRiskTimeEnabled {
                        ForEach(viewModel.customRiskTimes.indices, id: \.self) { index in
                            HStack {
                                Text(viewModel.customRiskTimes[index].name)
                                Spacer()
                                Text(viewModel.formatTimeRange(viewModel.customRiskTimes[index]))
                                    .foregroundColor(BFColors.textSecondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectedRiskTimeIndex = index
                                viewModel.isEditingCustomTime = true
                            }
                        }
                        
                        Button(action: {
                            viewModel.addCustomRiskTime()
                        }) {
                            Label("Add High-Risk Time", systemImage: "plus.circle")
                                .font(BFTheme.Typography.body())
                                .foregroundColor(BFColors.accent)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Get extra support during times when you're more likely to experience gambling urges")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.top, 4)
                    }
                }
                
                // Milestone celebrations
                Section(header: Text("Milestone Celebrations")) {
                    Toggle("Streak Milestones", isOn: $viewModel.isStreakMilestoneEnabled)
                        .tint(BFColors.accent)
                    
                    Toggle("Money Saved Milestones", isOn: $viewModel.isMoneySavedMilestoneEnabled)
                        .tint(BFColors.accent)
                    
                    Toggle("Tracking Milestone", isOn: $viewModel.isTrackingMilestoneEnabled)
                        .tint(BFColors.accent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Celebrate your achievements with notifications when you reach important milestones")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.top, 4)
                    }
                }
                
                // Notification style section
                Section(header: Text("Notification Style")) {
                    Picker("Notification Tone", selection: $viewModel.notificationTone) {
                        ForEach(NotificationTone.allCases) { tone in
                            Text(tone.displayName).tag(tone)
                        }
                    }
                    
                    Toggle("Include Sound", isOn: $viewModel.includeSound)
                        .tint(BFColors.accent)
                    
                    Toggle("Vibration", isOn: $viewModel.includeVibration)
                        .tint(BFColors.accent)
                    
                    Picker("Message Style", selection: $viewModel.messageStyle) {
                        ForEach(MessageStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                }
                
                // Notice
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notification Permission")
                            .font(BFTheme.Typography.headline())
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("BetFree needs permission to send you notifications. If you haven't enabled notifications yet, you'll be prompted to do so when you save these settings.")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                        
                        if !viewModel.hasNotificationPermission {
                            Button(action: {
                                viewModel.requestNotificationPermission()
                            }) {
                                Text("Request Permission")
                                    .font(BFTheme.Typography.button())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        BFColors.accent
                                            .cornerRadius(8)
                                    )
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveSettings()
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
            .sheet(isPresented: $viewModel.isShowingPaydayPicker) {
                PaydayPickerView(selectedDay: $viewModel.paydayDate, onSave: {
                    viewModel.isShowingPaydayPicker = false
                })
            }
            .sheet(isPresented: $viewModel.isEditingCustomTime) {
                if let index = viewModel.selectedRiskTimeIndex {
                    CustomRiskTimeEditor(
                        riskTime: $viewModel.customRiskTimes[index],
                        onSave: {
                            viewModel.isEditingCustomTime = false
                        }
                    )
                }
            }
        }
        .accentColor(BFColors.accent)
    }
}

// MARK: - Support Views

/// A view that allows the user to pick their payday date
struct PaydayPickerView: View {
    @Binding var selectedDay: Int
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Payday", selection: $selectedDay) {
                    ForEach(1...31, id: \.self) { day in
                        Text(day.ordinal).tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .padding()
                
                Text("If a month doesn't have this day, the last day of the month will be used instead")
                    .font(BFTheme.Typography.caption())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Payday")
        }
    }
}

/// A view that allows editing of a custom high-risk time
struct CustomRiskTimeEditor: View {
    @Binding var riskTime: CustomRiskTime
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var tempName: String
    @State private var tempStartTime: Date
    @State private var tempEndTime: Date
    @State private var tempDays: Set<ReminderWeekday>
    
    init(riskTime: Binding<CustomRiskTime>, onSave: @escaping () -> Void) {
        self._riskTime = riskTime
        self.onSave = onSave
        self._tempName = State(initialValue: riskTime.wrappedValue.name)
        self._tempStartTime = State(initialValue: riskTime.wrappedValue.startTime)
        self._tempEndTime = State(initialValue: riskTime.wrappedValue.endTime)
        self._tempDays = State(initialValue: riskTime.wrappedValue.days)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Risk Time Details")) {
                    TextField("Name (e.g. After Work)", text: $tempName)
                    
                    DatePicker("Start Time", selection: $tempStartTime, displayedComponents: .hourAndMinute)
                    
                    DatePicker("End Time", selection: $tempEndTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Days of Week")) {
                    ForEach(ReminderWeekday.allCases) { day in
                        Button {
                            if tempDays.contains(day) {
                                tempDays.remove(day)
                            } else {
                                tempDays.insert(day)
                            }
                        } label: {
                            HStack {
                                Text(day.displayName)
                                    .foregroundColor(BFColors.textPrimary)
                                
                                Spacer()
                                
                                if tempDays.contains(day) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(BFColors.accent)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        riskTime.name = tempName
                        riskTime.startTime = tempStartTime
                        riskTime.endTime = tempEndTime
                        riskTime.days = tempDays
                        onSave()
                    }) {
                        Text("Save Changes")
                            .foregroundColor(BFColors.accent)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Edit High-Risk Time")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        riskTime.name = tempName
                        riskTime.startTime = tempStartTime
                        riskTime.endTime = tempEndTime
                        riskTime.days = tempDays
                        onSave()
                    }
                    .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - View Model

/// View model for reminder settings
class ReminderSettingsViewModel: ObservableObject {
    // Daily reminder
    @Published var isDailyReminderEnabled: Bool = false
    @Published var dailyReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    
    // Idle reminder
    @Published var isIdleReminderEnabled: Bool = false
    @Published var idleHours: Int = 12
    
    // High-risk time alerts
    @Published var isWeekendAlertEnabled: Bool = false
    @Published var isPaydayAlertEnabled: Bool = false
    @Published var paydayDate: Int = 15
    @Published var isShowingPaydayPicker: Bool = false
    
    // Custom risk times
    @Published var isCustomRiskTimeEnabled: Bool = false
    @Published var customRiskTimes: [CustomRiskTime] = []
    @Published var isEditingCustomTime: Bool = false
    @Published var selectedRiskTimeIndex: Int? = nil
    
    // Milestone celebrations
    @Published var isStreakMilestoneEnabled: Bool = false
    @Published var isMoneySavedMilestoneEnabled: Bool = false
    @Published var isTrackingMilestoneEnabled: Bool = false
    
    // Notification style
    @Published var notificationTone: NotificationTone = .supportive
    @Published var includeSound: Bool = true
    @Published var includeVibration: Bool = true
    @Published var messageStyle: MessageStyle = .encouraging
    
    // Permission state
    @Published var hasNotificationPermission: Bool = false
    
    init() {
        loadSettings()
        checkNotificationPermission()
    }
    
    /// Loads saved settings from UserDefaults
    func loadSettings() {
        let defaults = UserDefaults.standard
        
        // Load daily reminder settings
        isDailyReminderEnabled = defaults.bool(forKey: "isDailyReminderEnabled")
        if let timeInterval = defaults.object(forKey: "dailyReminderTime") as? TimeInterval {
            dailyReminderTime = Date(timeIntervalSince1970: timeInterval)
        }
        
        // Load idle reminder settings
        isIdleReminderEnabled = defaults.bool(forKey: "isIdleReminderEnabled")
        idleHours = defaults.integer(forKey: "idleHours")
        if idleHours == 0 { idleHours = 12 }
        
        // Load high-risk time settings
        isWeekendAlertEnabled = defaults.bool(forKey: "isWeekendAlertEnabled")
        isPaydayAlertEnabled = defaults.bool(forKey: "isPaydayAlertEnabled")
        paydayDate = defaults.integer(forKey: "paydayDate")
        if paydayDate == 0 { paydayDate = 15 }
        
        // Load custom risk times
        isCustomRiskTimeEnabled = defaults.bool(forKey: "isCustomRiskTimeEnabled")
        if let savedData = defaults.data(forKey: "customRiskTimes"),
           let decoded = try? JSONDecoder().decode([CustomRiskTime].self, from: savedData) {
            customRiskTimes = decoded
        } else {
            // Setup default risk time if none exists
            let defaultRiskTime = CustomRiskTime(
                name: "Evening Hours",
                startTime: Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date(),
                endTime: Calendar.current.date(from: DateComponents(hour: 23, minute: 59)) ?? Date(),
                days: Set(ReminderWeekday.allCases)
            )
            customRiskTimes = [defaultRiskTime]
        }
        
        // Load milestone settings
        isStreakMilestoneEnabled = defaults.bool(forKey: "isStreakMilestoneEnabled")
        isMoneySavedMilestoneEnabled = defaults.bool(forKey: "isMoneySavedMilestoneEnabled")
        isTrackingMilestoneEnabled = defaults.bool(forKey: "isTrackingMilestoneEnabled")
        
        // Load notification style settings
        if let rawTone = defaults.string(forKey: "notificationTone"),
           let tone = NotificationTone(rawValue: rawTone) {
            notificationTone = tone
        }
        includeSound = defaults.bool(forKey: "includeSound")
        includeVibration = defaults.bool(forKey: "includeVibration")
        if let rawStyle = defaults.string(forKey: "messageStyle"),
           let style = MessageStyle(rawValue: rawStyle) {
            messageStyle = style
        }
    }
    
    /// Saves settings to UserDefaults
    func saveSettings() {
        let defaults = UserDefaults.standard
        
        // Save daily reminder settings
        defaults.set(isDailyReminderEnabled, forKey: "isDailyReminderEnabled")
        defaults.set(dailyReminderTime.timeIntervalSince1970, forKey: "dailyReminderTime")
        
        // Save idle reminder settings
        defaults.set(isIdleReminderEnabled, forKey: "isIdleReminderEnabled")
        defaults.set(idleHours, forKey: "idleHours")
        
        // Save high-risk time settings
        defaults.set(isWeekendAlertEnabled, forKey: "isWeekendAlertEnabled")
        defaults.set(isPaydayAlertEnabled, forKey: "isPaydayAlertEnabled")
        defaults.set(paydayDate, forKey: "paydayDate")
        
        // Save custom risk times
        defaults.set(isCustomRiskTimeEnabled, forKey: "isCustomRiskTimeEnabled")
        if let encoded = try? JSONEncoder().encode(customRiskTimes) {
            defaults.set(encoded, forKey: "customRiskTimes")
        }
        
        // Save milestone settings
        defaults.set(isStreakMilestoneEnabled, forKey: "isStreakMilestoneEnabled")
        defaults.set(isMoneySavedMilestoneEnabled, forKey: "isMoneySavedMilestoneEnabled")
        defaults.set(isTrackingMilestoneEnabled, forKey: "isTrackingMilestoneEnabled")
        
        // Save notification style settings
        defaults.set(notificationTone.rawValue, forKey: "notificationTone")
        defaults.set(includeSound, forKey: "includeSound")
        defaults.set(includeVibration, forKey: "includeVibration")
        defaults.set(messageStyle.rawValue, forKey: "messageStyle")
        
        // Schedule notifications based on settings
        scheduleReminders()
    }
    
    /// Check notification permission status
    func checkNotificationPermission() {
        // In a real app, you would use UNUserNotificationCenter to check permission status
        #if DEBUG
        // Simulate a check - in a real app this would be an async call to UNUserNotificationCenter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hasNotificationPermission = UserDefaults.standard.bool(forKey: "hasGrantedNotificationPermission")
        }
        #endif
    }
    
    /// Request notification permission
    func requestNotificationPermission() {
        // In a real app, you would use UNUserNotificationCenter to request authorization
        #if DEBUG
        // Simulate the permission request - in a real app this would show the system prompt
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Simulate user granting permission
            self.hasNotificationPermission = true
            UserDefaults.standard.set(true, forKey: "hasGrantedNotificationPermission")
        }
        #endif
    }
    
    /// Schedule reminders based on current settings
    func scheduleReminders() {
        // In a real app, this would use UNUserNotificationCenter to schedule notifications
        // based on the current settings
        print("Scheduling reminders with current settings")
        
        // This is where you would add the actual scheduling code using UNUserNotificationCenter
    }
    
    /// Add a new custom risk time
    func addCustomRiskTime() {
        let newRiskTime = CustomRiskTime(
            name: "New Risk Time",
            startTime: Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date(),
            endTime: Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date(),
            days: Set([.friday, .saturday])
        )
        customRiskTimes.append(newRiskTime)
        selectedRiskTimeIndex = customRiskTimes.count - 1
        isEditingCustomTime = true
    }
    
    /// Format the time range for display
    func formatTimeRange(_ riskTime: CustomRiskTime) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let startString = formatter.string(from: riskTime.startTime)
        let endString = formatter.string(from: riskTime.endTime)
        
        // Get day abbreviations
        let daysString = formatDays(riskTime.days)
        
        return "\(startString) - \(endString), \(daysString)"
    }
    
    /// Format days of week for display
    func formatDays(_ days: Set<ReminderWeekday>) -> String {
        if days.count == 7 {
            return "Everyday"
        }
        
        if days.count == 2 && days.contains(.saturday) && days.contains(.sunday) {
            return "Weekends"
        }
        
        if days.count == 5 && !days.contains(.saturday) && !days.contains(.sunday) {
            return "Weekdays"
        }
        
        let sortedDays = days.sorted(by: { $0.rawValue < $1.rawValue })
        let dayNames = sortedDays.map { $0.shortName }
        return dayNames.joined(separator: ", ")
    }
    
    /// Get formatted payday date
    var paydayDateFormatted: String {
        return "\(paydayDate.ordinal) of each month"
    }
}

// MARK: - Models

/// Enum representing days of the week
enum ReminderWeekday: Int, Codable, CaseIterable, Identifiable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }
}

/// Model for custom high-risk time
struct CustomRiskTime: Identifiable, Codable {
    var id = UUID()
    var name: String
    var startTime: Date
    var endTime: Date
    var days: Set<ReminderWeekday>
}

/// Enum for notification tones
enum NotificationTone: String, CaseIterable, Identifiable {
    case supportive = "supportive"
    case motivational = "motivational"
    case direct = "direct"
    case gentle = "gentle"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .supportive: return "Supportive"
        case .motivational: return "Motivational"
        case .direct: return "Direct & Firm"
        case .gentle: return "Gentle"
        }
    }
}

/// Enum for message styles
enum MessageStyle: String, CaseIterable, Identifiable {
    case encouraging = "encouraging"
    case factual = "factual"
    case stern = "stern"
    case questioning = "questioning"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .encouraging: return "Encouraging"
        case .factual: return "Factual"
        case .stern: return "Direct & Stern"
        case .questioning: return "Questioning"
        }
    }
}

// MARK: - Extensions

extension Int {
    /// Returns the number with an ordinal suffix (e.g. 1st, 2nd, 3rd, 4th)
    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

#Preview {
    ReminderSettingsView()
        .preferredColorScheme(.dark)
} 