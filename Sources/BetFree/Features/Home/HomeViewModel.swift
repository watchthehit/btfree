import Foundation
import SwiftUI
import BetFreeModels

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let timestamp: Date
    let amount: Double?
    
    static let preview: [Activity] = [
        Activity(
            title: "Daily Check-in",
            icon: "checkmark.circle.fill",
            color: .green,
            timestamp: Date(),
            amount: nil
        ),
        Activity(
            title: "Saved Money",
            icon: "dollarsign.circle.fill",
            color: .blue,
            timestamp: Date().addingTimeInterval(-3600),
            amount: 50.0
        ),
        Activity(
            title: "Resisted Craving",
            icon: "hand.raised.fill",
            color: .orange,
            timestamp: Date().addingTimeInterval(-7200),
            amount: nil
        )
    ]
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var hasCheckedInToday = false
    @Published private(set) var recentActivities: [Activity] = []
    
    private let dataManager: BetFreeDataManager
    private let defaults = UserDefaults.standard
    private let lastCheckInKey = "BFLastCheckIn"
    
    init() {
        let manager = CoreDataManager.shared
        self.dataManager = manager
        self.hasCheckedInToday = checkIfCheckedInToday()
        loadRecentActivities()
    }
    
    private func checkIfCheckedInToday() -> Bool {
        guard let lastCheckIn = defaults.object(forKey: lastCheckInKey) as? Date else {
            return false
        }
        return Calendar.current.isDateInToday(lastCheckIn)
    }
    
    private func loadRecentActivities() {
        recentActivities = Activity.preview
    }
    
    func performDailyCheckIn() async throws {
        try await dataManager.updateUserStreak()
        await MainActor.run {
            defaults.set(Date(), forKey: lastCheckInKey)
            
            let checkInActivity = Activity(
                title: "Daily Check-in",
                icon: "checkmark.circle.fill",
                color: .green,
                timestamp: Date(),
                amount: nil
            )
            
            withAnimation {
                recentActivities.insert(checkInActivity, at: 0)
                hasCheckedInToday = true
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState.preview)
} 