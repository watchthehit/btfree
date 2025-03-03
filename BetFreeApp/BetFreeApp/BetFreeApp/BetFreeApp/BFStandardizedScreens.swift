import SwiftUI

/**
 * BFStandardizedScreens - Pre-built screen layouts following the BetFree design system
 *
 * This file contains reusable, standardized screen layouts that should be used
 * as the foundation for creating consistent screens throughout the app.
 */

// MARK: - Standard Screen Container

/// Standard screen container with consistent styling
struct BFScreenContainer<Content: View>: View {
    let title: String
    let showBackButton: Bool
    let backAction: (() -> Void)?
    let content: Content
    
    init(
        title: String,
        showBackButton: Bool = true,
        backAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.backAction = backAction
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background
            BFColors.background
                .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    if showBackButton {
                        Button(action: {
                            backAction?()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .foregroundColor(BFColors.textPrimary)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(BFColors.cardBackground)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(BFTypography.heading3)
                        .foregroundColor(BFColors.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    
                    Spacer()
                    
                    // Invisible element for balance
                    if showBackButton {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, BFSpacing.screenHorizontal)
                .padding(.top, BFSpacing.medium)
                .padding(.bottom, BFSpacing.small)
                
                // Main Content
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - List Screen

/// Standard list screen with consistent styling
struct BFListScreen<Item: Identifiable, Content: View, EmptyContent: View>: View {
    let title: String
    let items: [Item]
    let emptyContent: EmptyContent
    let itemContent: (Item) -> Content
    
    init(
        title: String,
        items: [Item],
        @ViewBuilder emptyContent: () -> EmptyContent,
        @ViewBuilder itemContent: @escaping (Item) -> Content
    ) {
        self.title = title
        self.items = items
        self.emptyContent = emptyContent()
        self.itemContent = itemContent
    }
    
    var body: some View {
        BFScreenContainer(title: title) {
            if items.isEmpty {
                emptyContent
            } else {
                ScrollView {
                    LazyVStack(spacing: BFSpacing.medium) {
                        ForEach(items) { item in
                            itemContent(item)
                                .scaleAnimation(isActive: true, delay: 0.05 * Double(items.firstIndex(where: { $0.id == item.id }) ?? 0))
                        }
                    }
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.vertical, BFSpacing.medium)
                }
            }
        }
    }
}

// MARK: - Detail Screen

/// Standard detail screen with consistent styling
struct BFDetailScreen<HeaderContent: View, Content: View, FooterContent: View>: View {
    let title: String
    let headerContent: HeaderContent
    let content: Content
    let footerContent: FooterContent
    
    init(
        title: String,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footerContent: () -> FooterContent
    ) {
        self.title = title
        self.headerContent = headerContent()
        self.content = content()
        self.footerContent = footerContent()
    }
    
    var body: some View {
        BFScreenContainer(title: title) {
            VStack(spacing: 0) {
                // Header
                headerContent
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.top, BFSpacing.medium)
                
                // Main Content
                ScrollView {
                    content
                        .padding(.horizontal, BFSpacing.screenHorizontal)
                        .padding(.vertical, BFSpacing.medium)
                }
                
                // Footer
                footerContent
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.vertical, BFSpacing.medium)
                    .background(
                        Rectangle()
                            .fill(BFColors.cardBackground)
                            .shadow(color: Color.bfShadow(opacity: 0.05), radius: 5, x: 0, y: -3)
                    )
            }
        }
    }
}

// MARK: - Form Screen

/// Standard form screen with consistent styling
struct BFFormScreen<Content: View, FooterContent: View>: View {
    let title: String
    let content: Content
    let footerContent: FooterContent
    
    init(
        title: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footerContent: () -> FooterContent
    ) {
        self.title = title
        self.content = content()
        self.footerContent = footerContent()
    }
    
    var body: some View {
        BFScreenContainer(title: title) {
            VStack(spacing: 0) {
                // ScrollView for form fields
                ScrollView {
                    VStack(spacing: BFSpacing.large) {
                        content
                    }
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.vertical, BFSpacing.medium)
                }
                
                // Footer with buttons
                footerContent
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.vertical, BFSpacing.medium)
                    .background(
                        Rectangle()
                            .fill(BFColors.cardBackground)
                            .shadow(color: Color.bfShadow(opacity: 0.05), radius: 5, x: 0, y: -3)
                    )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Dashboard Screen

/// Standard dashboard screen with consistent styling
struct BFDashboardScreen<HeaderContent: View, Content: View>: View {
    let title: String
    let headerContent: HeaderContent
    let content: Content
    
    init(
        title: String,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.headerContent = headerContent()
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background
            BFColors.background
                .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: BFSpacing.medium) {
                    // Title
                    HStack {
                        Text(title)
                            .font(BFTypography.heading2)
                            .foregroundColor(BFColors.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        
                        Spacer()
                    }
                    
                    // Header Content
                    headerContent
                }
                .padding(.horizontal, BFSpacing.screenHorizontal)
                .padding(.top, BFSpacing.large)
                .padding(.bottom, BFSpacing.medium)
                
                // Main Content
                ScrollView {
                    content
                        .padding(.horizontal, BFSpacing.screenHorizontal)
                        .padding(.bottom, BFSpacing.large)
                }
            }
        }
    }
}

// MARK: - Preview Extensions

struct BFStandardizedScreens_Previews: PreviewProvider {
    // Sample model for previews
    struct SampleItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
    }
    
    static var previews: some View {
        Group {
            // List Screen Preview
            BFListScreen(
                title: "Activities",
                items: [
                    SampleItem(title: "Morning Meditation", subtitle: "10 minutes • Completed"),
                    SampleItem(title: "Urge Surfing", subtitle: "15 minutes • Mindfulness"),
                    SampleItem(title: "Breathing Exercise", subtitle: "5 minutes • Relaxation")
                ],
                emptyContent: {
                    BFEmptyState(
                        title: "No Activities Yet",
                        message: "Your completed mindfulness activities will appear here.",
                        icon: "list.bullet.circle",
                        buttonTitle: "Start Activity",
                        action: {}
                    )
                }
            ) { item in
                BFListItem(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: "checkmark.circle.fill",
                    iconColor: BFColors.success,
                    action: {}
                )
            }
            .previewDisplayName("List Screen")
            
            // Detail Screen Preview
            BFDetailScreen(
                title: "Mindfulness Session",
                headerContent: {
                    VStack(spacing: BFSpacing.small) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 50))
                            .foregroundColor(BFColors.accent)
                            .padding(.bottom, BFSpacing.small)
                        
                        Text("Deep Breathing Exercise")
                            .font(BFTypography.heading2)
                            .foregroundColor(BFColors.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("5 minutes • Beginner")
                            .font(BFTypography.bodyMedium)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .standardCardBackground()
                },
                content: {
                    VStack(alignment: .leading, spacing: BFSpacing.large) {
                        Text("Description")
                            .font(BFTypography.heading3)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("This exercise helps you focus on your breath to reduce stress and anxiety. Through controlled breathing, you can calm your nervous system and reduce gambling urges.")
                            .font(BFTypography.bodyMedium)
                            .foregroundColor(BFColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        BFProgressBar(value: 0.7, label: "Completion Rate")
                    }
                },
                footerContent: {
                    BFPrimaryButton(
                        title: "Begin Session",
                        icon: "play.fill",
                        action: {}
                    )
                }
            )
            .previewDisplayName("Detail Screen")
            
            // Form Screen Preview
            BFFormScreen(
                title: "Update Profile",
                content: {
                    VStack(alignment: .leading, spacing: BFSpacing.medium) {
                        Text("Personal Information")
                            .font(BFTypography.heading3)
                            .foregroundColor(BFColors.textPrimary)
                        
                        VStack(spacing: BFSpacing.medium) {
                            BFTextField(
                                placeholder: "Full Name",
                                icon: "person",
                                text: .constant("John Doe")
                            )
                            
                            BFTextField(
                                placeholder: "Email Address",
                                icon: "envelope",
                                text: .constant("john.doe@example.com")
                            )
                        }
                        
                        Text("Preferences")
                            .font(BFTypography.heading3)
                            .foregroundColor(BFColors.textPrimary)
                            .padding(.top, BFSpacing.medium)
                        
                        VStack(spacing: BFSpacing.small) {
                            // Toggles would go here
                            HStack {
                                Text("Daily Reminders")
                                    .font(BFTypography.bodyMedium)
                                    .foregroundColor(BFColors.textPrimary)
                                
                                Spacer()
                                
                                Text("On")
                                    .font(BFTypography.bodySmall)
                                    .foregroundColor(BFColors.textSecondary)
                            }
                            .padding()
                            .standardCardBackground()
                            
                            HStack {
                                Text("Progress Reports")
                                    .font(BFTypography.bodyMedium)
                                    .foregroundColor(BFColors.textPrimary)
                                
                                Spacer()
                                
                                Text("Weekly")
                                    .font(BFTypography.bodySmall)
                                    .foregroundColor(BFColors.textSecondary)
                            }
                            .padding()
                            .standardCardBackground()
                        }
                    }
                },
                footerContent: {
                    HStack(spacing: BFSpacing.medium) {
                        BFSecondaryButton(
                            title: "Cancel",
                            action: {}
                        )
                        
                        BFPrimaryButton(
                            title: "Save Changes",
                            action: {}
                        )
                    }
                }
            )
            .previewDisplayName("Form Screen")
            
            // Dashboard Screen Preview
            BFDashboardScreen(
                title: "Dashboard",
                headerContent: {
                    HStack(spacing: BFSpacing.medium) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .font(BFTypography.bodyLarge)
                                .fontWeight(.semibold)
                                .foregroundColor(BFColors.textPrimary)
                            
                            Text("Day 7 of your journey")
                                .font(BFTypography.bodySmall)
                                .foregroundColor(BFColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        BFBadge(text: "PRO", type: .premium)
                    }
                },
                content: {
                    VStack(spacing: BFSpacing.large) {
                        // Stats Card
                        BFStatsCard(title: "Your Progress", stats: [
                            ("Streak", "7 days"),
                            ("Saved", "$240"),
                            ("Mindful", "42 min")
                        ])
                        
                        // Info Card
                        BFInfoCard(title: "Daily Tip", icon: "lightbulb.fill") {
                            Text("Regular mindfulness practice can help reduce gambling urges by 65%.")
                                .font(BFTypography.bodyMedium)
                                .foregroundColor(BFColors.textSecondary)
                        }
                        
                        // Upcoming Sessions
                        VStack(alignment: .leading, spacing: BFSpacing.medium) {
                            Text("Upcoming Sessions")
                                .font(BFTypography.heading3)
                                .foregroundColor(BFColors.textPrimary)
                            
                            BFListItem(
                                title: "Deep Breathing",
                                subtitle: "Today • 5:00 PM",
                                icon: "clock",
                                action: {}
                            )
                            
                            BFListItem(
                                title: "Urge Surfing",
                                subtitle: "Tomorrow • 10:00 AM",
                                icon: "chart.bar",
                                action: {}
                            )
                        }
                    }
                }
            )
            .previewDisplayName("Dashboard Screen")
        }
    }
} 