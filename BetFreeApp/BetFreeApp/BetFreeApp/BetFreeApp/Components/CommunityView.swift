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
                    ProfileHeaderView(viewModel: viewModel)
                    
                    // Connect buttons
                    ConnectButtonsView(
                        showingInviteSheet: $showingInviteSheet,
                        showingQRCodeSheet: $showingQRCodeSheet
                    )
                    
                    // Leaderboard section
                    LeaderboardSectionView(viewModel: viewModel)
                    
                    // Recent activity section
                    ActivitySectionView(viewModel: viewModel)
                    
                    // Challenges section
                    ChallengesSectionView(viewModel: viewModel)
                }
                .padding(.bottom, 30)
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
                InviteBuddySheet(username: viewModel.username)
            }
            .sheet(isPresented: $showingQRCodeSheet) {
                QRCodeSheet(username: viewModel.username)
            }
        }
    }
}

// MARK: - Profile Header View
struct ProfileHeaderView: View {
    let viewModel: CommunityViewModel
    
    var body: some View {
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
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary)
                
                Text(viewModel.username)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(BFColors.textPrimary)
                
                Text("\(viewModel.streakDays) day streak · \(viewModel.buddiesCount) buddies")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// MARK: - Connect Buttons View
struct ConnectButtonsView: View {
    @Binding var showingInviteSheet: Bool
    @Binding var showingQRCodeSheet: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Invite button
            Button {
                showingInviteSheet = true
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 16))
                    Text("Invite")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
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
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(BFColors.textPrimary)
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
    }
}

// MARK: - Leaderboard Section View
struct LeaderboardSectionView: View {
    let viewModel: CommunityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LEADERBOARD")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .tracking(1)
                .padding(.leading)
            
            if viewModel.buddies.isEmpty {
                // Empty state
                EmptyLeaderboardView()
            } else {
                // Buddies list
                LeaderboardListView(buddies: viewModel.buddies, currentUserId: viewModel.userId)
            }
        }
    }
}

// MARK: - Empty Leaderboard View
struct EmptyLeaderboardView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2")
                .font(.system(size: 40))
                .foregroundColor(BFColors.textSecondary.opacity(0.5))
                .padding(.top, 20)
            
            Text("Connect with friends to see who can maintain the longest streak!")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Leaderboard List View
struct LeaderboardListView: View {
    let buddies: [LeaderboardEntry]
    let currentUserId: String
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(buddies) { entry in
                LeaderboardRowView(entry: entry, isCurrentUser: entry.id == currentUserId)
                
                if entry.id != buddies.last?.id {
                    Divider()
                        .background(BFColors.textSecondary.opacity(0.2))
                        .padding(.leading, 70)
                }
            }
        }
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Leaderboard Row View
struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(entry.rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(entry.rank <= 3 ? BFColors.accent : BFColors.textSecondary)
                .frame(width: 40)
            
            // Avatar or initials
            ZStack {
                Circle()
                    .fill(isCurrentUser ? BFColors.accent.opacity(0.2) : BFColors.cardBackground.opacity(0.5))
                    .frame(width: 40, height: 40)
                
                Text(entry.initials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isCurrentUser ? BFColors.accent : BFColors.textSecondary)
            }
            
            // Name and streak
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(isCurrentUser ? BFColors.accent : BFColors.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    
                    Text("\(entry.streakDays) day streak")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(isCurrentUser ? BFColors.accent.opacity(0.05) : BFColors.cardBackground)
    }
}

// MARK: - Activity Section View
struct ActivitySectionView: View {
    let viewModel: CommunityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENT ACTIVITY")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .tracking(1)
                .padding(.leading)
            
            if viewModel.recentActivity.isEmpty {
                // Empty state
                EmptyActivityView()
            } else {
                // Activity list
                ActivityListView(activities: viewModel.recentActivity)
            }
        }
    }
}

// MARK: - Empty Activity View
struct EmptyActivityView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 40))
                .foregroundColor(BFColors.textSecondary.opacity(0.5))
                .padding(.top, 20)
            
            Text("Recent activity from you and your buddies will appear here")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Activity List View
struct ActivityListView: View {
    let activities: [ActivityEntry]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(activities) { activity in
                ActivityRowView(activity: activity)
                
                if activity.id != activities.last?.id {
                    Divider()
                        .background(BFColors.textSecondary.opacity(0.2))
                        .padding(.leading, 70)
                }
            }
        }
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Activity Row View
struct ActivityRowView: View {
    let activity: ActivityEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar or initials
            ZStack {
                Circle()
                    .fill(BFColors.cardBackground.opacity(0.5))
                    .frame(width: 40, height: 40)
                
                Text(activity.userInitials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(BFColors.textSecondary)
            }
            
            // Activity description
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary)
                
                Text(activity.timeAgo)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Challenges Section View
struct ChallengesSectionView: View {
    let viewModel: CommunityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CHALLENGES")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .tracking(1)
                .padding(.leading)
            
            // Challenges list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if viewModel.challenges.isEmpty {
                        // Create challenge card
                        CreateChallengeCard()
                    } else {
                        // Create challenge card
                        CreateChallengeCard()
                        
                        // Challenge cards
                        ForEach(viewModel.challenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Create Challenge Card
struct CreateChallengeCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Button {
                // Handle create challenge
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 16))
                    Text("Create New Challenge")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(BFColors.accent)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(BFColors.accent, lineWidth: 2)
                )
            }
            
            Spacer()
        }
        .frame(width: 200, height: 160)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Challenge Card
struct ChallengeCard: View {
    let challenge: ChallengeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Challenge header
            HStack {
                ChallengeIconView(icon: challenge.icon, color: challenge.color, title: challenge.title, daysLeft: challenge.daysLeft)
            }
            
            // Progress bar
            ProgressView(value: challenge.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: challenge.color))
            
            // Description
            Text(challenge.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary.opacity(0.8))
                .lineLimit(2)
            
            // Footer stats
            HStack {
                Text("\(Int(challenge.progress * 100))% Complete")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary.opacity(0.7))
                
                Spacer()
                
                Text("\(challenge.participantCount) participants")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary.opacity(0.7))
            }
        }
        .padding(16)
        .frame(width: 280)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Challenge Icon View
struct ChallengeIconView: View {
    let icon: String
    let color: Color
    let title: String
    let daysLeft: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
            
            Spacer()
            
            Text("\(daysLeft) DAYS LEFT")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(BFColors.textSecondary.opacity(0.6))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(BFColors.textSecondary.opacity(0.1))
                )
        }
    }
}

// MARK: - Invite Buddy Sheet
struct InviteBuddySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var message = "Let's quit gambling together using BetFree!"
    
    let username: String
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Invite a Friend")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Support each other on your journey to bet-free living")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Form fields
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Friend's Email")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(BFColors.textSecondary)
                    
                    TextField("Enter email address", text: $email)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .padding()
                        .background(BFColors.cardBackground)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personal Message")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(BFColors.textSecondary)
                    
                    TextEditor(text: $message)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .padding()
                        .frame(height: 100)
                        .background(BFColors.cardBackground)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Send button
            Button {
                // Handle send invitation
                dismiss()
            } label: {
                Text("Send Invite")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(BFColors.accent)
                    )
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding(.top, 40)
        .background(BFColors.background.ignoresSafeArea())
    }
}

// MARK: - QR Code Sheet
struct QRCodeSheet: View {
    @Environment(\.dismiss) private var dismiss
    let username: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Your QR Code")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 40)
            
            Text("Friends can scan this to add you as a buddy")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // QR Code placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 220, height: 220)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Image(systemName: "qrcode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 20)
            
            Text(username)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 16)
            
            Spacer()
            
            Button("Close") {
                dismiss()
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(BFColors.textPrimary)
            .padding(.bottom, 40)
        }
        .background(BFColors.background.ignoresSafeArea())
    }
}

// MARK: - View Model and Data Models
class CommunityViewModel: ObservableObject {
    @Published var username = "John Doe"
    @Published var userId = "user123"
    @Published var userInitials = "JD"
    @Published var streakDays = 7
    @Published var buddiesCount = 3
    @Published var buddies: [LeaderboardEntry] = []
    @Published var recentActivity: [ActivityEntry] = []
    @Published var challenges: [ChallengeEntry] = []
    
    init() {
        // Load sample data
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Sample buddies
        buddies = [
            LeaderboardEntry(id: "user456", name: "Sarah Johnson", initials: "SJ", rank: 1, streakDays: 14),
            LeaderboardEntry(id: "user123", name: "John Doe", initials: "JD", rank: 2, streakDays: 7),
            LeaderboardEntry(id: "user789", name: "Mike Smith", initials: "MS", rank: 3, streakDays: 5),
            LeaderboardEntry(id: "user101", name: "Emma Wilson", initials: "EW", rank: 4, streakDays: 3)
        ]
        
        // Sample activity
        recentActivity = [
            ActivityEntry(id: "act1", userInitials: "SJ", description: "Sarah Johnson completed 14 days without gambling", timeAgo: "2 hours ago"),
            ActivityEntry(id: "act2", userInitials: "JD", description: "You completed 7 days without gambling", timeAgo: "1 day ago"),
            ActivityEntry(id: "act3", userInitials: "MS", description: "Mike Smith joined a new challenge", timeAgo: "2 days ago")
        ]
        
        // Sample challenges
        challenges = [
            ChallengeEntry(
                id: "challenge1",
                title: "30-Day Challenge",
                description: "Stay bet-free for 30 days with daily check-ins",
                icon: "calendar",
                color: .blue,
                progress: 0.23,
                daysLeft: 23,
                participantCount: 5
            ),
            ChallengeEntry(
                id: "challenge2",
                title: "Money Saver",
                description: "Save $500 by avoiding gambling for 2 weeks",
                icon: "dollarsign.circle",
                color: .green,
                progress: 0.5,
                daysLeft: 7,
                participantCount: 3
            )
        ]
    }
}

struct LeaderboardEntry: Identifiable {
    let id: String
    let name: String
    let initials: String
    let rank: Int
    let streakDays: Int
}

struct ActivityEntry: Identifiable {
    let id: String
    let userInitials: String
    let description: String
    let timeAgo: String
}

struct ChallengeEntry: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
    let progress: Double
    let daysLeft: Int
    let participantCount: Int
}

#Preview {
    CommunityView()
        .preferredColorScheme(.dark)
} 