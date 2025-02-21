import SwiftUI
import BetFree
import CoreData

@main
struct BetFreeApp: App {
    @StateObject private var appState: AppState
    private let persistenceController: BFPersistenceController
    
    init() {
        // Initialize persistence controller
        persistenceController = BFPersistenceController.shared
        print("Core Data container initialized")
        
        // Initialize app state with Core Data manager
        let dataManager = CoreDataManager.shared
        print("Data manager created")
        
        // Create StateObject
        _appState = StateObject(wrappedValue: AppState(dataManager: dataManager))
        print("App state initialized")
    }
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
    }
} 