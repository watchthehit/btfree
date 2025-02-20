import SwiftUI
import ComposableArchitecture
import BetFreeUI

@MainActor
public struct BetFreeRootView: View {
    @StateObject private var appState: AppState
    @State private var isLoading = true
    @State private var error: Error?
    
    @MainActor
    public init(dataManager: BetFreeDataManager = MockCDManager.shared) {
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
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second minimum loading time
                isLoading = false
            } catch {
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