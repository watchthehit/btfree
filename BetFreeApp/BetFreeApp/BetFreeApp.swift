import SwiftUI
import BetFree
import CoreData

@main
struct BetFreeApp: App {
    let persistenceController: BFPersistenceController
    @StateObject private var appState: AppState
    
    init() {
        // Initialize persistence controller
        persistenceController = BFPersistenceController.shared
        print("Core Data container initialized")
        
        // Initialize app state
        let dataManager = DataManagerFactory.createDataManager()
        print("Data manager created")
        
        // Create StateObject
        _appState = StateObject(wrappedValue: AppState(dataManager: dataManager))
        print("App state initialized")
    }
    
    var body: some Scene {
        WindowGroup {
            if !appState.isOnboarded {
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appState)
            }
        }
    }
    
    #if DEBUG
    private func createSampleDataIfNeeded() {
        let context = persistenceController.container.viewContext
        let fetchRequest = NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                print("Creating sample user profile")
                let user = UserProfileEntity(context: context)
                user.name = "Test User"
                user.email = "test@example.com"
                user.streak = 0
                user.totalSavings = 0
                user.dailyLimit = 100
                user.lastCheckIn = Date()
                
                try context.save()
                print("Sample data created successfully")
            }
        } catch {
            print("Error checking/creating sample data: \(error)")
        }
    }
    #endif
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Text("Welcome to BetFree")
                .font(.title)
                .padding()
            
            Text("Your journey to freedom starts here")
                .foregroundStyle(.secondary)
            
            // Display some state info for debugging
            VStack(alignment: .leading, spacing: 10) {
                Text("Debug Info:")
                    .font(.headline)
                Text("Is Onboarded: \(appState.isOnboarded ? "Yes" : "No")")
                Text("Username: \(appState.username)")
                Text("Current Streak: \(appState.currentStreak)")
                Text("Total Savings: $\(String(format: "%.2f", appState.totalSavings))")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding()
        }
        .onAppear {
            print("ContentView body appeared")
        }
    }
}