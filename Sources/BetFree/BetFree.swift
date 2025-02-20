import SwiftUI
import ComposableArchitecture
import BetFreeUI

@MainActor
public struct BetFreeRootView: View {
    @StateObject private var appState: AppState
    @State private var isLoading = true
    @State private var error: Error?
    
    @MainActor
    public init(dataManager: BetFreeDataManager = CoreDataManager.shared) {
        print("🔄 Initializing BetFreeRootView")
        _appState = StateObject(wrappedValue: AppState(dataManager: dataManager))
    }
    
    public var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if let error = error {
                ErrorView(error: error)
            } else if !appState.isOnboarded {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
        .animation(.easeInOut, value: appState.isOnboarded)
        .task {
            do {
                print("🔄 Starting app initialization")
                // Wait for Core Data to load
                if let coreDataManager = appState.dataManager as? CoreDataManager,
                   let persistenceController = coreDataManager.persistenceController {
                    try await persistenceController.waitForLoad()
                }
                
                // Minimum loading time for UX
                try await Task.sleep(nanoseconds: 500_000_000)
                
                print("✅ App initialization complete")
                isLoading = false
            } catch {
                print("❌ Error during initialization: \(error)")
                self.error = error
            }
        }
    }
}

private struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            SwiftUI.ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
    }
}

private struct ErrorView: View {
    let error: Error
    @State private var showingDetails = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(BFDesignSystem.Colors.error)
            
            Text("Failed to Initialize")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(error.localizedDescription)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: { showingDetails.toggle() }) {
                Label(showingDetails ? "Hide Details" : "Show Details", 
                      systemImage: showingDetails ? "chevron.up" : "chevron.down")
            }
            .padding()
            
            if showingDetails {
                ScrollView {
                    Text(String(describing: error))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        .padding()
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(8)
                }
                .frame(maxHeight: 200)
                .padding()
            }
            
            Button(action: {
                // Force quit the app to allow a clean restart
                exit(1)
            }) {
                Label("Quit App", systemImage: "power")
                    .foregroundColor(BFDesignSystem.Colors.error)
            }
            .padding()
        }
    }
}

// MARK: - Preview Support
public struct BetFreePreview: View {
    @StateObject private var appState = AppState.preview
    
    public var body: some View {
        BetFreeRootView()
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

@MainActor
public struct BetFree {
    public static func initialize() {
        // Initialize app-wide settings here
    }
}

@MainActor
public var previewContent: some View {
    BetFreePreview()
}

@MainActor
public var content: some View {
    BetFreeRootView()
}