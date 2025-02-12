import SwiftUI
import ComposableArchitecture

public struct BetFreeRootView: View {
    @StateObject private var appState: AppState
    
    public var body: some View {
        ZStack {
            // Set background color at root level
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            NavigationView {
                ZStack {
                    if appState.isOnboarded {
                        MainTabView(appState: appState)
                    } else {
                        OnboardingView()
                            .environmentObject(appState)
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    public init() {
        // Initialize Core Data
        _ = CoreDataManager.shared
        
        // Initialize AppState
        _appState = StateObject(wrappedValue: AppState())
        
        // Set navigation bar appearance
        #if canImport(UIKit)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }
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
    
    public var body: some Scene {
        WindowGroup {
            if !appState.isOnboarded {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView(appState: appState)
            }
        }
    }
    
    public init() {}
}

#Preview {
    BetFreeRootView()
}

#Preview("Onboarding") {
    OnboardingView()
        .environmentObject(AppState())
}

#Preview("Dashboard") {
    DashboardView(appState: AppState())
}

@MainActor
public var previewContent: some View {
    BetFreeRootView()
}

@MainActor
public var previewContentOnboarded: some View {
    BetFreeRootView()
} 