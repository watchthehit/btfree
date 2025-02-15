import SwiftUI

public struct HomeView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to BetFree Home")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
} 