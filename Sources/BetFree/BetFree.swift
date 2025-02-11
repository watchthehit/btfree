import SwiftUI
import ComposableArchitecture

public struct BetFreeRootView: View {
    @StateObject private var appState: AppState
    let store: StoreOf<AppFeature>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if !appState.isOnboarded {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                MainTabView()
                    .environmentObject(appState)
            }
        }
    }
    
    public init(appState: AppState = .shared, store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) {
        AppFeature()
    }) {
        _appState = StateObject(wrappedValue: appState)
        self.store = store
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

#Preview("Onboarding Flow") {
    let appState = AppState()
    appState.isOnboarded = false  // Force onboarding
    return BetFreeRootView(appState: appState)
}

#Preview("Main App") {
    let appState = AppState()
    appState.isOnboarded = true  // Force main app
    appState.updateUsername("John")
    appState.updateDailyLimit(100)
    appState.updateStreak(7)
    appState.updateSavings(500)
    return BetFreeRootView(appState: appState)
} 