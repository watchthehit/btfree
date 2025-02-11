import SwiftUI
import ComposableArchitecture

public struct ResourcesView: View {
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Emergency Support
                ResourceSection(
                    title: "Emergency Support",
                    items: [
                        ResourceItem(
                            title: "National Problem Gambling Helpline",
                            description: "24/7 confidential support",
                            actionText: "Call 1-800-522-4700",
                            systemImage: "phone.fill",
                            color: .red
                        ),
                        ResourceItem(
                            title: "Crisis Text Line",
                            description: "Text HOME to 741741",
                            actionText: "Send Text",
                            systemImage: "message.fill",
                            color: .blue
                        )
                    ]
                )
                
                // Support Groups
                ResourceSection(
                    title: "Support Groups",
                    items: [
                        ResourceItem(
                            title: "Gamblers Anonymous",
                            description: "Find local meetings",
                            actionText: "Find Meetings",
                            systemImage: "person.3.fill",
                            color: .green
                        ),
                        ResourceItem(
                            title: "Online Support Community",
                            description: "Connect with others",
                            actionText: "Join Forum",
                            systemImage: "globe",
                            color: .purple
                        )
                    ]
                )
            }
            .padding()
        }
        .navigationTitle("Resources")
    }
    
    public init() {}
}

struct ResourceSection: View {
    let title: String
    let items: [ResourceItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(items) { item in
                ResourceItemView(item: item)
            }
        }
    }
}

struct ResourceItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let actionText: String
    let systemImage: String
    let color: Color
}

struct ResourceItemView: View {
    let item: ResourceItem
    
    var body: some View {
        HStack {
            Image(systemName: item.systemImage)
                .font(.title2)
                .foregroundColor(item.color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Handle resource action
            }) {
                Text(item.actionText)
                    .foregroundColor(BFDesignSystem.Colors.primary)
            }
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(10)
    }
}

#Preview {
    ResourcesView()
        .environmentObject(AppState.shared)
} 