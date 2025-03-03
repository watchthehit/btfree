import SwiftUI

/**
 * BFStandardizedComponents - Pre-built UI components following the BetFree design system
 *
 * This file contains reusable, standardized UI components that should be used
 * throughout the app to ensure consistency in appearance and behavior.
 */

// MARK: - Cards

/// Standard information card with consistent styling
struct BFInfoCard<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content
    
    init(title: String, icon: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                        .foregroundColor(BFColors.accent)
                }
                
                Text(title)
                    .font(BFTypography.heading3)
                    .foregroundColor(BFColors.textPrimary)
            }
            
            content
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
}

/// Standard statistics card for data visualization
struct BFStatsCard: View {
    let title: String
    let stats: [(label: String, value: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            Text(title)
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            HStack(spacing: BFSpacing.large) {
                ForEach(stats, id: \.label) { stat in
                    VStack(spacing: BFSpacing.tiny) {
                        Text(stat.value)
                            .font(BFTypography.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text(stat.label)
                            .font(BFTypography.bodySmall)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    
                    if stat.label != stats.last?.label {
                        Divider()
                            .background(BFColors.divider)
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, BFSpacing.small)
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
}

// MARK: - Buttons

/// Standard primary action button
struct BFPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isDisabled: Bool
    
    init(title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(BFTypography.button)
                }
                
                Text(title)
                    .font(BFTypography.button)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, BFSpacing.medium)
            .foregroundColor(.bfWhite)
            .background(isDisabled ? Color.bfGray() : BFColors.accent)
            .cornerRadius(BFCornerRadius.medium)
        }
        .disabled(isDisabled)
    }
}

/// Standard secondary action button
struct BFSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(BFTypography.button)
                }
                
                Text(title)
                    .font(BFTypography.button)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, BFSpacing.medium)
            .foregroundColor(BFColors.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .stroke(BFColors.divider, lineWidth: 1)
            )
        }
    }
}

// MARK: - List Items

/// Standard list item with icon
struct BFListItem: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let isLocked: Bool
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = BFColors.accent,
        isLocked: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.isLocked = isLocked
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.medium) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: BFSpacing.tiny) {
                    HStack {
                        Text(title)
                            .font(BFTypography.bodyMedium)
                            .foregroundColor(BFColors.textPrimary)
                        
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.caption2)
                                .foregroundColor(BFColors.accent)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(BFColors.textTertiary)
                    }
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(BFTypography.bodySmall)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
            }
            .padding()
            .standardCardBackground()
        }
    }
}

// MARK: - Input Elements

/// Standard text input field
struct BFTextField: View {
    let placeholder: String
    let icon: String?
    @Binding var text: String
    let isSecure: Bool
    
    init(placeholder: String, icon: String? = nil, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self.icon = icon
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack(spacing: BFSpacing.small) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(BFColors.textTertiary)
                    .frame(width: 24)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(BFTypography.bodyMedium)
            } else {
                TextField(placeholder, text: $text)
                    .font(BFTypography.bodyMedium)
            }
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(BFCornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                .stroke(BFColors.divider, lineWidth: 1)
        )
    }
}

// MARK: - Progress Indicators

/// Standard progress bar
struct BFProgressBar: View {
    let value: Double // 0.0 to 1.0
    let label: String?
    
    init(value: Double, label: String? = nil) {
        self.value = min(max(value, 0.0), 1.0)
        self.label = label
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFSpacing.tiny) {
            if let label = label {
                HStack {
                    Text(label)
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(value * 100))%")
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(BFColors.secondaryBackground)
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(BFColors.accent)
                        .frame(width: geometry.size.width * CGFloat(value), height: 8)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Status Indicators

/// Standard badge indicator
struct BFBadge: View {
    enum BadgeType {
        case success
        case warning
        case error
        case info
        case premium
        
        var color: Color {
            switch self {
            case .success: return BFColors.success
            case .warning: return BFColors.warning
            case .error: return BFColors.error
            case .info: return BFColors.info
            case .premium: return BFColors.accent
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .premium: return "crown.fill"
            }
        }
    }
    
    let text: String
    let type: BadgeType
    
    var body: some View {
        HStack(spacing: BFSpacing.tiny) {
            Image(systemName: type.icon)
                .font(.caption2)
            
            Text(text)
                .font(BFTypography.caption)
        }
        .padding(.horizontal, BFSpacing.small)
        .padding(.vertical, 4)
        .foregroundColor(.bfWhite)
        .background(type.color)
        .cornerRadius(BFCornerRadius.small)
    }
}

// MARK: - Empty States

/// Standard empty state view
struct BFEmptyState: View {
    let title: String
    let message: String
    let icon: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        message: String,
        icon: String,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: BFSpacing.large) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(BFColors.textSecondary)
            
            VStack(spacing: BFSpacing.small) {
                Text(title)
                    .font(BFTypography.heading3)
                    .foregroundColor(BFColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let buttonTitle = buttonTitle, let action = action {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(BFTypography.button)
                        .foregroundColor(.bfWhite)
                        .padding(.horizontal, BFSpacing.large)
                        .padding(.vertical, BFSpacing.medium)
                        .background(BFColors.accent)
                        .cornerRadius(BFCornerRadius.medium)
                }
            }
        }
        .padding(BFSpacing.large)
    }
}

// MARK: - Preview Extensions

struct BFStandardizedComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: BFSpacing.large) {
                // Cards
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Cards")
                        .font(BFTypography.heading2)
                    
                    BFInfoCard(title: "Daily Tip", icon: "lightbulb.fill") {
                        Text("Regular mindfulness practice can help reduce gambling urges by 65%.")
                            .font(BFTypography.bodyMedium)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    
                    BFStatsCard(title: "Your Progress", stats: [
                        ("Streak", "7 days"),
                        ("Saved", "$240"),
                        ("Mindful", "42 min")
                    ])
                }
                
                // Buttons
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Buttons")
                        .font(BFTypography.heading2)
                    
                    BFPrimaryButton(title: "Start Session", icon: "play.fill") {}
                    BFPrimaryButton(title: "Can't Use This", icon: "lock.fill", isDisabled: true) {}
                    BFSecondaryButton(title: "View History", icon: "clock") {}
                }
                
                // List Items
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("List Items")
                        .font(BFTypography.heading2)
                    
                    BFListItem(
                        title: "Deep Breathing",
                        subtitle: "5 min • Breathing Technique",
                        icon: "lungs.fill",
                        action: {}
                    )
                    
                    BFListItem(
                        title: "Urge Surfing",
                        subtitle: "10 min • Premium Technique",
                        icon: "wave.3.right",
                        isLocked: true,
                        action: {}
                    )
                }
                
                // Input Fields
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Input Fields")
                        .font(BFTypography.heading2)
                    
                    BFTextField(
                        placeholder: "Email Address",
                        icon: "envelope",
                        text: .constant("user@example.com")
                    )
                    
                    BFTextField(
                        placeholder: "Password",
                        icon: "lock",
                        text: .constant("password"),
                        isSecure: true
                    )
                }
                
                // Progress Indicators
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Progress Indicators")
                        .font(BFTypography.heading2)
                    
                    BFProgressBar(value: 0.67, label: "Weekly Goal")
                    BFProgressBar(value: 0.35)
                }
                
                // Status Indicators
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Status Indicators")
                        .font(BFTypography.heading2)
                    
                    HStack {
                        BFBadge(text: "Complete", type: .success)
                        BFBadge(text: "Attention", type: .warning)
                        BFBadge(text: "Failed", type: .error)
                        BFBadge(text: "New", type: .info)
                        BFBadge(text: "Pro", type: .premium)
                    }
                }
                
                // Empty State
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Empty State")
                        .font(BFTypography.heading2)
                    
                    BFEmptyState(
                        title: "No Sessions Yet",
                        message: "Start your first mindfulness session to see your progress here.",
                        icon: "sparkles",
                        buttonTitle: "Start Now",
                        action: {}
                    )
                }
            }
            .padding()
        }
    }
} 