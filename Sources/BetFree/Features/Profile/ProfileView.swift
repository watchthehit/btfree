import SwiftUI
import ComposableArchitecture
import BetFreeUI

public struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingLogoutAlert = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Text("Profile View - Coming Soon")
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState.preview)
} 