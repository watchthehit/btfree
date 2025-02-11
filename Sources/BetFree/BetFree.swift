import SwiftUI
import ComposableArchitecture

public struct BetFreeRootView: View {
    @StateObject private var appState = AppState()
    
    public var body: some View {
        if !appState.isOnboarded {
            OnboardingView()
                .environmentObject(appState)
        } else {
            MainTabView()
                .environmentObject(appState)
        }
    }
    
    public init() {}
}

public struct AppFeature: Reducer {
    public struct State: Equatable {
        var count: Int = 0
        
        public init() {}
    }
    
    public enum Action {
        case incrementButtonTapped
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
    
    public init() {}
}

// Renamed to avoid collision with the app's main struct
struct BetFreeLibraryPreviewApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if !appState.isOnboarded {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview("Onboarding Flow") {
    BetFreeRootView()
        .onAppear {
            let appState = AppState()
            appState.isOnboarded = false
        }
}

#Preview("Main App") {
    BetFreeRootView()
        .onAppear {
            let appState = AppState()
            appState.isOnboarded = true
            appState.updateUsername("John")
            appState.updateDailyLimit(100)
            appState.updateStreak(7)
            appState.updateSavings(500)
        }
}

public var previewContent: some View {
    let appState = AppState()
    appState.isOnboarded = false  // Force onboarding
    return BetFreeRootView()
}

public var previewContentOnboarded: some View {
    let appState = AppState()
    appState.isOnboarded = true
    appState.updateStreak(7)
    appState.updateSavings(500)
    return BetFreeRootView()
} 