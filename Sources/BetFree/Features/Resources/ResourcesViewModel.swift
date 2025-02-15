import SwiftUI

@MainActor
public class ResourcesViewModel: ObservableObject {
    @Published var resources: [Resource] = []
    @Published var isLoading = false
    @Published var error: String?
    
    init() {
        loadResources()
    }
    
    private func loadResources() {
        resources = [
            Resource(
                title: "24/7 Sports Betting Helpline",
                description: "Immediate support for sports betting urges and crisis situations",
                icon: "phone.fill",
                type: .emergency,
                action: .call("1-800-522-4700")
            ),
            Resource(
                title: "Local GA Meetings",
                description: "Find Gamblers Anonymous meetings focused on sports betting recovery",
                icon: "person.3.fill",
                type: .support,
                action: .website("https://www.gamblersanonymous.org/meetings")
            ),
            Resource(
                title: "Sports Betting Recovery Guide",
                description: "Comprehensive guide for overcoming sports betting addiction",
                icon: "book.fill",
                type: .educational,
                action: .article("sports-betting-recovery")
            ),
            Resource(
                title: "Emergency Contact",
                description: "Contact your designated emergency support person",
                icon: "exclamationmark.triangle.fill",
                type: .emergency,
                action: .contact
            ),
            Resource(
                title: "Block Betting Apps",
                description: "Step-by-step guide to block sports betting apps and websites",
                icon: "hand.raised.fill",
                type: .tools,
                action: .article("blocking-guide")
            ),
            Resource(
                title: "Financial Recovery",
                description: "Tools and guidance for financial healing",
                icon: "dollarsign.circle.fill",
                type: .tools,
                action: .article("financial-recovery")
            ),
            Resource(
                title: "Game Day Strategies",
                description: "Coping strategies for managing urges during games",
                icon: "sportscourt.fill",
                type: .educational,
                action: .article("game-day-coping")
            ),
            Resource(
                title: "Chat with Counselor",
                description: "Connect with a gambling addiction specialist",
                icon: "message.fill",
                type: .support,
                action: .chat
            )
        ]
    }
    
    func handleResourceAction(_ action: ResourceAction) {
        switch action {
        case .call(let number):
            if let url = URL(string: "tel://\(number)") {
                #if os(iOS)
                UIApplication.shared.open(url)
                #endif
            }
        case .website(let urlString):
            if let url = URL(string: urlString) {
                #if os(iOS)
                UIApplication.shared.open(url)
                #endif
            }
        case .article, .contact, .chat:
            // Handle in view
            break
        }
    }
}

public struct Resource: Identifiable {
    public let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: ResourceType
    let action: ResourceAction
}

public enum ResourceType {
    case emergency
    case support
    case educational
    case tools
    
    var color: Color {
        switch self {
        case .emergency:
            return BFDesignSystem.Colors.error
        case .support:
            return BFDesignSystem.Colors.success
        case .educational:
            return BFDesignSystem.Colors.primary
        case .tools:
            return BFDesignSystem.Colors.warning
        }
    }
}

public enum ResourceAction {
    case call(String)
    case website(String)
    case article(String)
    case contact
    case chat
}
