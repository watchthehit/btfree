import SwiftUI

/// A view that enables social support and accountability through friend connections
struct CommunityView: View {
    @StateObject private var viewModel = CommunityViewModel()
    @State private var showingInviteSheet = false
    @State private var showingQRCodeSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with profile summary
                    HStack(spacing: 16) {
                        // Profile image
                        ZStack {
                            Circle()
                                .fill(BFColors.cardBackground)
                                .frame(width: 70, height: 70)
                            
                            Text(viewModel.userInitials)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(BFColors.accent)
                        }
                        
                        // Stats
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Profile")
                                .font(BFTheme.Typography.caption())
                                .foregroundColor(BFColors.textSecondary)
                            
                            Text(viewModel.username)
                                .font(BFTheme.Typography.headline())
                                .foregroundColor(BFColors.textPrimary)
                            
                            Text("\(viewModel.streakDays) day streak · \(viewModel.buddiesCount) buddies")
                                .font(BFTheme.Typography.body(14))
                                .foregroundColor(BFColors.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Connect buttons
                    HStack(spacing: 12) {
                        // Invite button
                        Button {
                            showingInviteSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 16))
                                Text("Invite")
                                    .font(BFTheme.Typography.button(14))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(BFColors.primary)
                            )
                        }
                        
                        // QR Code button
                        Button {
                            showingQRCodeSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 16))
                                Text("My Code")
                                    .font(BFTheme.Typography.button(14))
                            }
                            .foregroundColor(BFColors.textDark)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(BFColors.textSecondary)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Leaderboard section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("LEADERBOARD")
                            .font(BFTheme.Typography.caption(12))
                            .foregroundColor(BFColors.textSecondary)
                            .tracking(1)
                            .padding(.leading)
                        
                        if viewModel.buddies.isEmpty {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "person.2")
                                    .font(.system(size: 40))
                                    .foregroundColor(BFColors.textTertiary)
                                    .padding(.top, 20)
                                
                                Text("Connect with friends to see who can maintain the longest streak!")
                                    .font(BFTheme.Typography.body())
                                    .foregroundColor(BFColors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .padding(.bottom, 20)
                            }
                            .frame(maxWidth: .infinity)
                            .background(BFColors.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        } else {
                            // Leaderboard list
                            VStack(spacing: 0) {
                                ForEach(viewModel.leaderboardEntries) { entry in
                                    LeaderboardRow(entry: entry, isCurrentUser: entry.id == viewModel.currentUserId)
                                    
                                    if entry.id != viewModel.leaderboardEntries.last?.id {
                                        Divider()
                                            .background(BFColors.divider)
                                            .padding(.leading, 70)
                                    }
                                }
                            }
                            .background(BFColors.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent activity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RECENT ACTIVITY")
                            .font(BFTheme.Typography.caption(12))
                            .foregroundColor(BFColors.textSecondary)
                            .tracking(1)
                            .padding(.leading)
                        
                        VStack(spacing: 0) {
                            ForEach(viewModel.activityFeed) { activity in
                                ActivityRow(activity: activity)
                                
                                if activity.id != viewModel.activityFeed.last?.id {
                                    Divider()
                                        .background(BFColors.divider)
                                        .padding(.leading, 56)
                                }
                            }
                        }
                        .background(BFColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    // Challenge section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CHALLENGES")
                            .font(BFTheme.Typography.caption(12))
                            .foregroundColor(BFColors.textSecondary)
                            .tracking(1)
                            .padding(.leading)
                        
                        VStack(spacing: 16) {
                            // Current challenge card
                            ChallengeCard(
                                title: "7-Day Clean Challenge",
                                description: "Stay gambling-free for 7 consecutive days",
                                icon: "flag.fill",
                                color: .green,
                                participantCount: 12,
                                progress: 0.4,
                                daysLeft: 4
                            )
                            
                            Button {
                                // Create challenge action
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 16))
                                    Text("Create New Challenge")
                                        .font(BFTheme.Typography.button(14))
                                }
                                .foregroundColor(BFColors.accent)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(BFColors.accent.opacity(0.5), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(BFColors.accent.opacity(0.05))
                                        )
                                )
                            }
                        }
                        .padding()
                        .background(BFColors.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .background(BFColors.background.ignoresSafeArea())
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // Scan QR code
                        }) {
                            Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                        }
                        
                        Button(action: {
                            // Find friends
                        }) {
                            Label("Find Friends", systemImage: "magnifyingglass")
                        }
                        
                        Button(action: {
                            // Manage buddies
                        }) {
                            Label("Manage Buddies", systemImage: "person.2.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                            .foregroundColor(BFColors.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingInviteSheet) {
                InviteBuddySheet()
            }
            .sheet(isPresented: $showingQRCodeSheet) {
                QRCodeSheet(username: viewModel.username)
            }
        }
    }
}

// MARK: - Row Components

/// A row that displays a leaderboard entry
struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("\(entry.rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(rankColor)
                .frame(width: 30)
            
            // Profile image
            ZStack {
                Circle()
                    .fill(entry.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(entry.initials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(entry.color)
            }
            
            // Name and streak
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(BFTheme.Typography.body())
                    .foregroundColor(isCurrentUser ? BFColors.accent : BFColors.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(entry.streakColor)
                    
                    Text("\(entry.streakDays) day streak")
                        .font(BFTheme.Typography.caption())
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            Spacer()
            
            // Badges if applicable
            if entry.badges.contains("new") {
                Text("NEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.cornerRadius(4))
            }
            
            if entry.badges.contains("fast") {
                Text("🚀")
                    .font(.system(size: 14))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(isCurrentUser ? BFColors.accent.opacity(0.05) : Color.clear)
    }
    
    var rankColor: Color {
        switch entry.rank {
        case 1:
            return Color.yellow
        case 2:
            return Color.gray.opacity(0.8)
        case 3:
            return Color(hex: "#CD7F32") // Bronze
        default:
            return BFColors.textTertiary
        }
    }
}

/// A row that displays an activity feed item
struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile image
            ZStack {
                Circle()
                    .fill(activity.color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Text(activity.userInitials)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(activity.color)
            }
            
            // Activity description
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.description)
                    .font(BFTheme.Typography.body(14))
                    .foregroundColor(BFColors.textSecondary)
                
                Text(activity.timeAgo)
                    .font(BFTheme.Typography.caption(12))
                    .foregroundColor(BFColors.textSecondary.opacity(0.6))
            }
            
            Spacer()
            
            // Activity icon
            Image(systemName: activity.icon)
                .font(.system(size: 16))
                .foregroundColor(activity.iconColor)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

/// A card that displays a challenge
struct ChallengeCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let participantCount: Int
    let progress: Double
    let daysLeft: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(BFTheme.Typography.headline())
                    .foregroundColor(BFColors.textSecondary)
                
                Spacer()
                
                Text("\(daysLeft) DAYS LEFT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.1))
                    )
            }
            
            Text(description)
                .font(BFTheme.Typography.body(14))
                .foregroundColor(BFColors.textSecondary.opacity(0.8))
            
            // Progress bar with proper tint styling
            VStack(spacing: 6) {
                ProgressView(value: progress)
                    .tint(BFColors.accent)
                
                HStack {
                    Text("\(Int(progress * 100))% Complete")
                        .font(BFTheme.Typography.caption())
                        .foregroundColor(BFColors.textSecondary.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(participantCount) participants")
                        .font(BFTheme.Typography.caption())
                        .foregroundColor(BFColors.textSecondary.opacity(0.7))
                }
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Sheet Views

/// A sheet that allows the user to invite buddies
struct InviteBuddySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var message = "Join me on BetFree to track our gambling-free progress together!"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header image
                Image(systemName: "person.2.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFColors.accent)
                    .padding(.top, 20)
                
                Text("Invite a Buddy")
                    .font(BFTheme.Typography.title())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Support each other on your journey to bet-free living")
                    .font(BFTheme.Typography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    // Email input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Friend's Email")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                        
                        TextField("Enter email address", text: $email)
                            .font(BFTheme.Typography.body())
                            .padding()
                            .background(BFColors.cardBackground)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    // Message input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Personal Message")
                            .font(BFTheme.Typography.caption())
                            .foregroundColor(BFColors.textSecondary)
                        
                        TextEditor(text: $message)
                            .font(BFTheme.Typography.body())
                            .padding()
                            .frame(height: 100)
                            .background(BFColors.cardBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Send invite button
                Button {
                    // Send invite action
                    dismiss()
                } label: {
                    Text("Send Invite")
                        .font(BFTheme.Typography.button())
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [BFColors.accent, BFColors.accent.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(16)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .disabled(email.isEmpty)
                .opacity(email.isEmpty ? 0.6 : 1)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// A sheet that displays the user's QR code for adding buddies
struct QRCodeSheet: View {
    @Environment(\.dismiss) private var dismiss
    let username: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Your QR Code")
                .font(BFTheme.Typography.title())
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 40)
            
            Text("Friends can scan this to add you as a buddy")
                .font(BFTheme.Typography.body())
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // QR code placeholder
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 220, height: 220)
                
                // In a real app, this would be a generated QR code
                // For now, just show a placeholder
                Image(systemName: "qrcode")
                    .font(.system(size: 150))
                    .foregroundColor(.black)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            Text(username)
                .font(BFTheme.Typography.headline())
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 16)
            
            Spacer()
            
            Button("Close") {
                dismiss()
            }
            .font(BFTheme.Typography.button())
            .foregroundColor(BFColors.textPrimary)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - View Model and Data Models

/// View model for the community view
class CommunityViewModel: ObservableObject {
    @Published var username: String = "John D."
    @Published var userInitials: String = "JD"
    @Published var streakDays: Int = 5
    @Published var buddiesCount: Int = 3
    @Published var currentUserId: String = "user-123"
    @Published var buddies: [User] = []
    @Published var leaderboardEntries: [LeaderboardEntry] = []
    @Published var activityFeed: [ActivityItem] = []
    
    init() {
        // In a real app, this would load from a backend service
        // For this demo, load sample data
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Sample buddies
        buddies = [
            User(id: "user-456", name: "Sarah P.", initials: "SP"),
            User(id: "user-789", name: "Mike R.", initials: "MR"),
            User(id: "user-234", name: "Emma L.", initials: "EL")
        ]
        
        // Sample leaderboard
        leaderboardEntries = [
            LeaderboardEntry(id: "user-456", rank: 1, name: "Sarah P.", initials: "SP", streakDays: 14, color: .orange, streakColor: .orange, badges: ["fast"]),
            LeaderboardEntry(id: "user-789", rank: 2, name: "Mike R.", initials: "MR", streakDays: 9, color: .blue, streakColor: .blue, badges: []),
            LeaderboardEntry(id: "user-123", rank: 3, name: "John D.", initials: "JD", streakDays: 5, color: BFColors.accent, streakColor: BFColors.accent, badges: ["new"]),
            LeaderboardEntry(id: "user-234", rank: 4, name: "Emma L.", initials: "EL", streakDays: 3, color: .purple, streakColor: .purple, badges: [])
        ]
        
        // Sample activity feed
        activityFeed = [
            ActivityItem(id: UUID().uuidString, userInitials: "SP", description: "Sarah reached a 14-day streak", timeAgo: "2 hours ago", icon: "flame.fill", iconColor: .orange, color: .orange),
            ActivityItem(id: UUID().uuidString, userInitials: "MR", description: "Mike saved $50 by not gambling", timeAgo: "Yesterday", icon: "dollarsign.circle.fill", iconColor: .green, color: .blue),
            ActivityItem(id: UUID().uuidString, userInitials: "JD", description: "You joined the 7-Day Challenge", timeAgo: "2 days ago", icon: "flag.fill", iconColor: .green, color: BFColors.accent),
            ActivityItem(id: UUID().uuidString, userInitials: "EL", description: "Emma resisted 5 urges today", timeAgo: "3 days ago", icon: "hand.raised.fill", iconColor: .blue, color: .purple)
        ]
    }
}

/// Model for a user
struct User: Identifiable {
    let id: String
    let name: String
    let initials: String
}

/// Model for a leaderboard entry
struct LeaderboardEntry: Identifiable {
    let id: String
    let rank: Int
    let name: String
    let initials: String
    let streakDays: Int
    let color: Color
    let streakColor: Color
    let badges: [String]
}

/// Model for an activity feed item
struct ActivityItem: Identifiable {
    let id: String
    let userInitials: String
    let description: String
    let timeAgo: String
    let icon: String
    let iconColor: Color
    let color: Color
}

#Preview {
    CommunityView()
        .preferredColorScheme(.dark)
} 