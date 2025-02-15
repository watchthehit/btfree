import SwiftUI
import BetFree
import CoreData

@main
struct BetFreeApp: App {
    let persistenceController = BFPersistenceController.shared
    @StateObject private var appState = AppState(syncDataManager: DataManagerFactory.createDataManager())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BetFreeRootView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appState)
            }
        }
    }
}