import SwiftUI
import BetFreeUI

public struct ResourcesView: View {
    @StateObject private var viewModel = ResourcesViewModel()
    @State private var selectedResource: Resource?
    @State private var showArticle = false
    @State private var showEmergencyContact = false
    @State private var showChatView = false
    @State private var isAnimated = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Emergency Support Card
                    BFCard(style: .elevated, gradient: LinearGradient(
                        colors: [BFDesignSystem.Colors.error, BFDesignSystem.Colors.error.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) {
                        Button {
                            showEmergencyContact = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Need Immediate Help?")
                                        .font(BFDesignSystem.Typography.titleMedium)
                                        .foregroundColor(.white)
                                    
                                    Text("24/7 Support Available")
                                        .font(BFDesignSystem.Typography.bodyMedium)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "phone.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Resources Grid
                    LazyVGrid(
                        columns: [GridItem(.flexible())],
                        spacing: 16
                    ) {
                        ForEach(Array(viewModel.resources.enumerated()), id: \.element.id) { index, resource in
                            ResourceCard(resource: resource) {
                                handleResourceTap(resource)
                            }
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)
                            .animation(.spring(response: 0.6).delay(Double(index) * 0.1), value: isAnimated)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
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
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
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
        BFCard(style: .elevated, gradient: resource.gradient) {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: resource.categoryIcon)
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(resource.title)
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(.white)
                        
                        Text(resource.description)
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                    }
                }
                .padding()
            }
        }
    }
}

private extension Resource {
    var gradient: LinearGradient {
        switch self.type {
        case .emergency:
            return LinearGradient(
                colors: [BFDesignSystem.Colors.error, BFDesignSystem.Colors.error.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .educational:
            return LinearGradient(
                colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .support:
            return LinearGradient(
                colors: [BFDesignSystem.Colors.success, BFDesignSystem.Colors.success.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .tools:
            return LinearGradient(
                colors: [BFDesignSystem.Colors.error, BFDesignSystem.Colors.error.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var categoryIcon: String {
        switch self.type {
        case .emergency:
            return "exclamationmark.triangle.fill"
        case .educational:
            return "book.fill"
        case .support:
            return "person.2.fill"
        case .tools:
            return "hammer.fill"
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
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
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
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
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
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    ResourcesView()
}