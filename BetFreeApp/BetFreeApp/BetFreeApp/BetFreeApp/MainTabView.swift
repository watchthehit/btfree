import SwiftUI

/**
 * MainTabView
 * The main tab interface after onboarding, featuring a tracking-focused approach
 */

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showTrackButton = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                // Track tab (main tracking interface)
                BetTrackingView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Track")
                    }
                
                // Progress tab (stats and insights)
                ProgressView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Progress")
                    }
                
                // Journal tab
                JournalView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "book")
                        Text("Journal")
                    }
                
                // Community tab (Quit Buddies)
                CommunityView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Buddies")
                    }
                
                // Settings tab
                SettingsView()
                    .tag(4)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
            .accentColor(BFColors.accent)
            
            // Quick track floating button for easy access from any tab
            if showTrackButton && selectedTab != 0 {
                Button {
                    // Animate to track tab
                    withAnimation {
                        selectedTab = 0
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("Track Urge")
                            .font(BFTypography.button(16))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        Capsule()
                            .fill(BFColors.accent)
                            .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.bottom, 70) // Position above tab bar
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Placeholder Views for other tabs (DEPRECATED - Using standalone components instead)

// Note: These placeholders are kept for reference but are no longer used
// The app now uses the standalone components in their respective files

struct ProgressPlaceholderView: View {
    var body: some View {
        ZStack {
            BFColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Progress & Insights")
                    .font(BFTypography.title())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Track your journey to bet-free living with detailed stats and insights")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Placeholder for stats
                StatisticCard(title: "Current Streak", value: "14", subtitle: "DAYS", icon: "flame.fill")
                
                StatisticCard(title: "Money Saved", value: "$342", subtitle: "TOTAL", icon: "dollarsign.circle.fill")
                
                StatisticCard(title: "Urges Resisted", value: "86%", subtitle: "THIS MONTH", icon: "chart.line.uptrend.xyaxis")
            }
            .padding()
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(BFColors.accent)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(BFColors.accent.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
                    .tracking(0.5)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text(subtitle)
                        .font(BFTypography.caption(12))
                        .foregroundColor(BFColors.textTertiary)
                        .padding(.bottom, 4)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(BFColors.cardBackground)
        )
        .padding(.horizontal, 16)
    }
}

struct JournalView: View {
    var body: some View {
        ZStack {
            BFColors.background
                .ignoresSafeArea()
            
            VStack {
                Text("Journal")
                    .font(BFTypography.title())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Track your thoughts and triggers to understand your gambling patterns")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
                // Quick add entry button
                Button {
                    // Add journal entry action
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("New Entry")
                            .font(BFTypography.button(16))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(BFColors.primary)
                    )
                }
                .padding(.bottom, 20)
                
                // Placeholder for empty state
                Text("No journal entries yet")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textTertiary)
                    .padding(.top, 60)
            }
        }
    }
}

struct CommunityPlaceholderView: View {
    var body: some View {
        ZStack {
            BFColors.background
                .ignoresSafeArea()
            
            VStack {
                Text("Quit Buddies")
                    .font(BFTypography.title())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Connect with friends to stay accountable and motivated")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
                // Add buddy button
                Button {
                    // Add buddy action
                } label: {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18))
                        
                        Text("Invite Buddy")
                            .font(BFTypography.button(16))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(BFColors.primary)
                    )
                }
                .padding(.bottom, 20)
                
                // Leaderboard preview
                VStack(alignment: .leading, spacing: 0) {
                    Text("LEADERBOARD")
                        .font(BFTypography.caption())
                        .foregroundColor(BFColors.textSecondary)
                        .tracking(1)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    Divider()
                        .background(BFColors.divider)
                    
                    Text("Invite friends to see who can maintain the longest streak")
                        .font(BFTypography.body(15))
                        .foregroundColor(BFColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(40)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(BFColors.cardBackground)
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        ZStack {
            BFColors.background
                .ignoresSafeArea()
            
            VStack {
                Text("Settings")
                    .font(BFTypography.title())
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                // Settings options
                VStack(spacing: 0) {
                    SettingsRow(title: "My Account", icon: "person.circle")
                    SettingsRow(title: "Daily Goals", icon: "target")
                    SettingsRow(title: "Notifications", icon: "bell")
                    SettingsRow(title: "Upgrade to Premium", icon: "star.fill", isPremium: true)
                    SettingsRow(title: "Privacy", icon: "lock.shield")
                    SettingsRow(title: "Help & Support", icon: "questionmark.circle")
                    SettingsRow(title: "About", icon: "info.circle")
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(BFColors.cardBackground)
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    var isPremium: Bool = false
    
    var body: some View {
        Button {
            // Handle tap
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isPremium ? BFColors.accent : BFColors.primary)
                    .frame(width: 32, height: 32)
                
                Text(title)
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(BFColors.textTertiary)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
        
        if title != "About" {
            Divider()
                .background(BFColors.divider)
                .padding(.leading, 60)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .preferredColorScheme(.dark)
    }
} 