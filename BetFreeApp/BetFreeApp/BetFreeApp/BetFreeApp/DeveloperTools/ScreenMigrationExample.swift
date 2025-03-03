import SwiftUI

/**
 * ScreenMigrationExample - Before/After Example of UI Standardization
 *
 * This file demonstrates how to migrate a screen from using direct SwiftUI components
 * to using the standardized components and styles from the BetFree design system.
 *
 * NOTE: This file is intended for DEVELOPMENT ONLY and should not be included in
 * production builds.
 */

// MARK: - Migration Example Screen

struct ScreenMigrationExample: View {
    @State private var showingAfter = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Screen Migration Example")
                    .font(BFTypography.heading2)
                    .foregroundColor(BFColors.textPrimary)
                
                Spacer()
                
                // Toggle button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingAfter.toggle()
                    }
                }) {
                    Text(showingAfter ? "Show Original" : "Show Standardized")
                        .font(BFTypography.bodySmall)
                        .foregroundColor(.bfWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: BFCornerRadius.small)
                                .fill(BFColors.accent)
                        )
                }
            }
            .padding(.horizontal, BFSpacing.screenHorizontal)
            .padding(.top, BFSpacing.medium)
            .padding(.bottom, BFSpacing.small)
            
            // Tab switcher
            HStack(spacing: 0) {
                tabButton(title: "Before", isSelected: !showingAfter)
                tabButton(title: "After", isSelected: showingAfter)
            }
            .padding(.horizontal, BFSpacing.screenHorizontal)
            
            // Content
            ZStack {
                // Before screen
                if !showingAfter {
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("UI Components - Original")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Description
                            Text("This is a non-standardized screen using direct SwiftUI components with inconsistent colors, fonts, and spacing.")
                                .font(.system(size: 16))
                                .foregroundColor(Color.gray)
                            
                            // Original components
                            originalButtonsSection
                            originalCardSection
                            originalListSection
                        }
                        .padding(20)
                    }
                    .transition(.opacity.combined(with: .move(edge: .leading)))
                }
                
                // After screen
                if showingAfter {
                    ScrollView {
                        VStack(spacing: BFSpacing.large) {
                            Text("UI Components - Standardized")
                                .font(BFTypography.heading3)
                                .foregroundColor(BFColors.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Description
                            Text("This is the same screen migrated to use standardized components with consistent colors, fonts, and spacing from the BetFree design system.")
                                .font(BFTypography.bodyMedium)
                                .foregroundColor(BFColors.textSecondary)
                            
                            // Standardized components
                            standardizedButtonsSection
                            standardizedCardSection
                            standardizedListSection
                        }
                        .padding(.horizontal, BFSpacing.screenHorizontal)
                        .padding(.vertical, BFSpacing.medium)
                    }
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            
            // Code diff viewer
            VStack(alignment: .leading, spacing: BFSpacing.small) {
                Text("Code Comparison")
                    .font(BFTypography.heading3)
                    .foregroundColor(BFColors.textPrimary)
                
                codeDiffView(
                    before: showingAfter ? getRelevantBeforeCode() : getBeforeCode(),
                    after: showingAfter ? getRelevantAfterCode() : getAfterCode()
                )
            }
            .padding(.horizontal, BFSpacing.screenHorizontal)
            .padding(.vertical, BFSpacing.medium)
        }
        .background(BFColors.background.edgesIgnoringSafeArea(.all))
    }
    
    // Tab button
    private func tabButton(title: String, isSelected: Bool) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingAfter = title == "After"
            }
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(isSelected ? BFColors.accent : BFColors.textSecondary)
                
                Rectangle()
                    .fill(isSelected ? BFColors.accent : Color.clear)
                    .frame(height: 2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Original Components
    
    private var originalButtonsSection: some View {
        VStack(spacing: 16) {
            Text("Buttons")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Primary button
            Button(action: {}) {
                Text("Primary Action")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#F95738"))
                    )
            }
            
            // Secondary button
            Button(action: {}) {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Secondary Action")
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    private var originalCardSection: some View {
        VStack(spacing: 16) {
            Text("Card")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Info card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#64FFDA"))
                    
                    Text("Daily Tip")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.black)
                }
                
                Text("Regular mindfulness practice can help reduce gambling urges by 65%.")
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    private var originalListSection: some View {
        VStack(spacing: 16) {
            Text("List Items")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // List item 1
            HStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#F95738"))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color(hex: "#F95738").opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Deep Breathing")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.black)
                    
                    Text("5 min • Breathing Technique")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            
            // List item 2
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#64FFDA"))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color(hex: "#64FFDA").opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Premium Feature")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.black)
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#F95738"))
                    }
                    
                    Text("Only available to subscribers")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - Standardized Components
    
    private var standardizedButtonsSection: some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            Text("Buttons")
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: BFSpacing.medium) {
                // Primary button
                BFPrimaryButton(title: "Primary Action", action: {})
                
                // Secondary button
                BFSecondaryButton(title: "Secondary Action", icon: "arrow.right", action: {})
            }
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
    
    private var standardizedCardSection: some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            Text("Card")
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Info card
            BFInfoCard(title: "Daily Tip", icon: "lightbulb.fill") {
                Text("Regular mindfulness practice can help reduce gambling urges by 65%.")
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
    
    private var standardizedListSection: some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            Text("List Items")
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: BFSpacing.medium) {
                // List item 1
                BFListItem(
                    title: "Deep Breathing",
                    subtitle: "5 min • Breathing Technique",
                    icon: "heart.fill",
                    iconColor: BFColors.accent,
                    action: {}
                )
                
                // List item 2
                BFListItem(
                    title: "Premium Feature",
                    subtitle: "Only available to subscribers",
                    icon: "star.fill",
                    iconColor: BFColors.secondary,
                    isLocked: true,
                    action: {}
                )
            }
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
    
    // MARK: - Code Diff View
    
    private func codeDiffView(before: String, after: String) -> some View {
        VStack(spacing: BFSpacing.small) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Before:")
                        .font(BFTypography.bodySmall)
                        .foregroundColor(BFColors.error)
                        .padding(.bottom, 4)
                    
                    Text(before)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(BFColors.textPrimary)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(BFColors.error.opacity(0.05))
                        .cornerRadius(BFCornerRadius.small)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("After:")
                        .font(BFTypography.bodySmall)
                        .foregroundColor(BFColors.success)
                        .padding(.vertical, 4)
                    
                    Text(after)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(BFColors.textPrimary)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(BFColors.success.opacity(0.05))
                        .cornerRadius(BFCornerRadius.small)
                }
            }
            .frame(height: 300)
        }
    }
    
    // MARK: - Code Samples
    
    // Full before code
    private func getBeforeCode() -> String {
        """
        VStack(spacing: 24) {
            Text("UI Components - Original")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.black)
            
            // Original components (non-standardized)
            VStack(spacing: 16) {
                Text("Buttons")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                
                // Primary button
                Button(action: {}) {
                    Text("Primary Action")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#F95738"))
                        )
                }
                
                // Secondary button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("Secondary Action")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
            )
        }
        .padding(20)
        """
    }
    
    // Full after code
    private func getAfterCode() -> String {
        """
        VStack(spacing: BFSpacing.large) {
            Text("UI Components - Standardized")
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            // Standardized components
            VStack(alignment: .leading, spacing: BFSpacing.medium) {
                Text("Buttons")
                    .font(BFTypography.heading3)
                    .foregroundColor(BFColors.textPrimary)
                
                VStack(spacing: BFSpacing.medium) {
                    // Primary button
                    BFPrimaryButton(title: "Primary Action", action: {})
                    
                    // Secondary button
                    BFSecondaryButton(
                        title: "Secondary Action",
                        icon: "arrow.right",
                        action: {}
                    )
                }
            }
            .padding(BFSpacing.medium)
            .standardCardBackground()
        }
        .padding(.horizontal, BFSpacing.screenHorizontal)
        .padding(.vertical, BFSpacing.medium)
        """
    }
    
    // Specific component before code
    private func getRelevantBeforeCode() -> String {
        if showingAfter {
            switch selectedSection {
            case "buttons":
                return """
                // Primary button
                Button(action: {}) {
                    Text("Primary Action")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#F95738"))
                        )
                }
                
                // Secondary button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("Secondary Action")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                """
            case "card":
                return """
                // Info card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#64FFDA"))
                        
                        Text("Daily Tip")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.black)
                    }
                    
                    Text("Regular mindfulness practice can help...")
                        .font(.system(size: 16))
                        .foregroundColor(Color.gray)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 8)
                )
                """
            case "list":
                return """
                // List item 1
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#F95738"))
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color(hex: "#F95738").opacity(0.1))
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Deep Breathing")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.black)
                        
                        Text("5 min • Breathing Technique")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                )
                """
            default:
                return getBeforeCode()
            }
        } else {
            return getBeforeCode()
        }
    }
    
    // Specific component after code
    private func getRelevantAfterCode() -> String {
        if showingAfter {
            switch selectedSection {
            case "buttons":
                return """
                // Primary button
                BFPrimaryButton(title: "Primary Action", action: {})
                
                // Secondary button
                BFSecondaryButton(
                    title: "Secondary Action",
                    icon: "arrow.right",
                    action: {}
                )
                """
            case "card":
                return """
                // Info card
                BFInfoCard(title: "Daily Tip", icon: "lightbulb.fill") {
                    Text("Regular mindfulness practice can help...")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textSecondary)
                }
                """
            case "list":
                return """
                // List item
                BFListItem(
                    title: "Deep Breathing",
                    subtitle: "5 min • Breathing Technique",
                    icon: "heart.fill",
                    iconColor: BFColors.accent,
                    action: {}
                )
                """
            default:
                return getAfterCode()
            }
        } else {
            return getAfterCode()
        }
    }
    
    // Currently selected section for code diff
    private var selectedSection: String {
        switch showingAfter {
        case true where scrollPosition.y < 600:
            return "buttons"
        case true where scrollPosition.y < 900:
            return "card"
        case true where scrollPosition.y < 1200:
            return "list"
        default:
            return ""
        }
    }
    
    // Simulated scroll position (this would be more sophisticated in a real implementation)
    private var scrollPosition: CGPoint {
        return CGPoint(x: 0, y: 500)
    }
}

// MARK: - Helper Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview Provider

struct ScreenMigrationExample_Previews: PreviewProvider {
    static var previews: some View {
        ScreenMigrationExample()
    }
} 