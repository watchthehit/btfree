import SwiftUI

public struct ResourcesView: View {
    @StateObject private var viewModel = ResourcesViewModel()
    @State private var selectedResource: Resource?
    @State private var showArticle = false
    @State private var showEmergencyContact = false
    @State private var showChatView = false
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible())],
                    spacing: 16
                ) {
                    ForEach(viewModel.resources) { resource in
                        ResourceCard(resource: resource) {
                            handleResourceTap(resource)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Recovery Resources")
            .sheet(isPresented: $showArticle) {
                if let resource = selectedResource,
                   case let .article(articleId) = resource.action {
                    ArticleView(articleId: articleId)
                }
            }
            .sheet(isPresented: $showEmergencyContact) {
                EmergencyContactView()
            }
            .sheet(isPresented: $showChatView) {
                CounselorChatView()
            }
        }
    }
    
    private func handleResourceTap(_ resource: Resource) {
        selectedResource = resource
        
        switch resource.action {
        case .article:
            showArticle = true
        case .contact:
            showEmergencyContact = true
        case .chat:
            showChatView = true
        default:
            viewModel.handleResourceAction(resource.action)
        }
    }
}

private struct ResourceCard: View {
    let resource: Resource
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: resource.icon)
                    .font(.title2)
                    .foregroundColor(resource.type.color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(resource.title)
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    
                    Text(resource.description)
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(resource.type.color.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

private struct ArticleView: View {
    let articleId: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Article content would go here
                Text("Article: \(articleId)")
                    .padding()
            }
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct EmergencyContactView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Emergency contact UI would go here
                Text("Emergency Contact")
                    .padding()
            }
            .navigationTitle("Emergency Contact")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct CounselorChatView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Chat UI would go here
                Text("Chat with Counselor")
                    .padding()
            }
            .navigationTitle("Chat with Counselor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ResourcesView()
}