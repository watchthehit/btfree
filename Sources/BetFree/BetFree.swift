import SwiftUI
import ComposableArchitecture

public struct BetFreeRootView: View {
    @EnvironmentObject var appState: AppState
    
    public var body: some View {
        ZStack {
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            if !appState.isOnboarded {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
    }
    
    public init() {
        // Initialize Core Data
        _ = CoreDataManager.shared
        
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
    @State private var appState: AppState?
    @State private var isLoading = true
    
    public var body: some Scene {
        WindowGroup {
            Group {
                if let appState = appState {
                    if !appState.isOnboarded {
                        OnboardingView()
                            .environmentObject(appState)
                    } else {
                        MainTabView()
                            .environmentObject(appState)
                    }
                } else if isLoading {
                    SwiftUI.ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Failed to initialize app state")
                }
            }
            .task {
                self.appState = AppState.preview()
                isLoading = false
            }
        }
    }
}

struct PreviewAppState: View {
    @State private var appState: AppState?
    @State private var isLoading = true
    let content: (AppState) -> any View
    
    init(@ViewBuilder content: @escaping (AppState) -> any View) {
        self.content = content
    }
    
    var body: some View {
        Group {
            if let appState = appState {
                AnyView(content(appState))
            } else if isLoading {
                SwiftUI.ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("Failed to initialize preview state")
            }
        }
        .task {
            self.appState = AppState.preview()
            isLoading = false
        }
    }
}

#Preview("Onboarding") {
    BetFreeRootView()
}

#Preview("Dashboard") {
    BetFreeRootView()
}

@MainActor
public struct BetFree {
    public init() {}
}

@MainActor
public var previewContent: some View {
    PreviewAppState { appState in
        BetFreeRootView()
            .environmentObject(appState)
    }
}

@MainActor
public var previewContentOnboarded: some View {
    PreviewAppState { appState in
        BetFreeRootView()
            .environmentObject(appState)
    }
} 