import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    @Published var isAuthenticated = false
    @Published var hasCompletedOnboarding = false
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthenticationService
    
    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
        setupBindings()
    }
    
    private func setupBindings() {
        authService.$currentUser
            .map { $0 != nil }
            .assign(to: &$isAuthenticated)
    }
    
    func navigate(to route: AppRoute) {
        withAnimation {
            currentRoute = route
        }
    }
}

enum AppRoute {
    case splash
    case onboarding
    case authentication
    case main
}

struct CoordinatorView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .splash:
                SplashView()
            case .onboarding:
                OnboardingView()
            case .authentication:
                AuthenticationView()
            case .main:
                MainTabView()
            }
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
} 