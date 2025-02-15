import SwiftUI
import ComposableArchitecture

public struct BetFreeRootView: View {
    @EnvironmentObject var appState: AppState
    
    public init() {}
    
    public var body: some View {
        Group {
            if !appState.isOnboarded {
                OnboardingView()
            } else {
                TabView(selection: $appState.selectedTab) {
                    DashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "chart.bar.fill")
                        }
                        .tag(0)
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(1)
                    
                    SavingsView()
                        .tabItem {
                            Label("Savings", systemImage: "dollarsign.circle.fill")
                        }
                        .tag(2)
                    
                    CravingView()
                        .tabItem {
                            Label("Cravings", systemImage: "brain.head.profile")
                        }
                        .tag(3)
                }
            }
        }
    }
}

// MARK: - Preview Support
public struct BetFreePreview: View {
    @StateObject private var appState = AppState.preview
    
    public var body: some View {
        BetFreeRootView()
            .environmentObject(appState)
    }
}

#Preview("Root View") {
    BetFreePreview()
}

#Preview("Dashboard") {
    DashboardView()
        .environmentObject(AppState.preview)
}

#Preview("Profile") {
    ProfileView()
        .environmentObject(AppState.preview)
}

#Preview("Savings") {
    SavingsView()
        .environmentObject(AppState.preview)
}

#Preview("Cravings") {
    CravingView()
        .environmentObject(AppState.preview)
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
                self.appState = AppState.preview
                isLoading = false
            }
        }
    }
}

@MainActor
public struct BetFree {
    public init() {}
}

@MainActor
public var previewContent: some View {
    BetFreePreview()
}

@MainActor
public var content: some View {
    BetFreePreview()
}