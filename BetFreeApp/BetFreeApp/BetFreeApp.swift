import SwiftUI
import BetFree

@main
struct BetFreeApp: App {
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
        }
    }
}

struct MainView: View {
    var body: some View {
        BetFreeRootView()
    }
} 