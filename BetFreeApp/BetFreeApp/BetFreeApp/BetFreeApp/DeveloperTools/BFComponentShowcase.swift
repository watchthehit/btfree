import SwiftUI

/**
 * BFComponentShowcase - Interactive showcase of all standardized UI components
 *
 * This file serves as a living catalog of all standardized UI components available
 * in the BetFree app. It's meant to be used by developers to explore available
 * components, see examples, and understand proper usage.
 *
 * NOTE: This file is intended for DEVELOPMENT ONLY and should not be included in
 * production builds.
 */

// MARK: - Component Showcase Screen

struct BFComponentShowcase: View {
    @State private var selectedSection: ComponentSection = .buttons
    @State private var showingSectionPicker = false
    @State private var searchText = ""
    @State private var sampleText = "Sample text"
    @State private var sampleToggle = true
    @State private var sampleProgress = 0.67
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with section picker
                HStack {
                    Text("BetFree UI Components")
                        .font(BFTypography.heading2)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showingSectionPicker.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.headline)
                            .foregroundColor(BFColors.accent)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(BFColors.accent.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, BFSpacing.screenHorizontal)
                .padding(.top, BFSpacing.medium)
                .padding(.bottom, BFSpacing.small)
                
                // Section Filter Dropdown
                if showingSectionPicker {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: BFSpacing.small) {
                            ForEach(ComponentSection.allCases, id: \.self) { section in
                                Button(action: {
                                    withAnimation {
                                        selectedSection = section
                                        showingSectionPicker = false
                                    }
                                }) {
                                    Text(section.title)
                                        .font(BFTypography.bodySmall)
                                        .padding(.horizontal, BFSpacing.small)
                                        .padding(.vertical, 8)
                                        .foregroundColor(selectedSection == section ? .bfWhite : BFColors.textPrimary)
                                        .background(
                                            RoundedRectangle(cornerRadius: BFCornerRadius.small)
                                                .fill(selectedSection == section ? BFColors.accent : BFColors.cardBackground)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, BFSpacing.screenHorizontal)
                        .padding(.bottom, BFSpacing.small)
                    }
                }
                
                // Component list
                ScrollView {
                    VStack(alignment: .leading, spacing: BFSpacing.large) {
                        Text(selectedSection.title)
                            .font(BFTypography.heading3)
                            .foregroundColor(BFColors.textPrimary)
                            .padding(.bottom, BFSpacing.tiny)
                        
                        // Description
                        Text(selectedSection.description)
                            .font(BFTypography.bodyMedium)
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.bottom, BFSpacing.medium)
                        
                        // Component showcase based on selected section
                        sectionContent
                    }
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                    .padding(.top, BFSpacing.medium)
                    .padding(.bottom, BFSpacing.xlarge)
                }
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
    
    // Display different content based on selected section
    @ViewBuilder
    var sectionContent: some View {
        switch selectedSection {
        case .buttons:
            buttonShowcase
        case .cards:
            cardShowcase
        case .inputs:
            inputShowcase
        case .lists:
            listShowcase
        case .indicators:
            indicatorShowcase
        case .screens:
            screenShowcase
        case .animations:
            animationShowcase
        case .typography:
            typographyShowcase
        case .colors:
            colorShowcase
        case .spacing:
            spacingShowcase
        }
    }
    
    // Button showcase
    var buttonShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Primary Button", code: "BFPrimaryButton(title: \"Label\", action: {})") {
                VStack(spacing: BFSpacing.medium) {
                    BFPrimaryButton(title: "Standard Button", action: {})
                    BFPrimaryButton(title: "With Icon", icon: "star.fill", action: {})
                    BFPrimaryButton(title: "Disabled", icon: "lock.fill", isDisabled: true, action: {})
                }
            }
            
            componentSection(title: "Secondary Button", code: "BFSecondaryButton(title: \"Label\", action: {})") {
                VStack(spacing: BFSpacing.medium) {
                    BFSecondaryButton(title: "Standard Button", action: {})
                    BFSecondaryButton(title: "With Icon", icon: "arrow.right", action: {})
                }
            }
            
            usage(
                title: "Button Usage Guidelines",
                guidelines: [
                    "Use Primary buttons for main actions",
                    "Use Secondary buttons for alternative options",
                    "Always include descriptive labels",
                    "Keep button text concise (1-3 words)",
                    "Use icons to reinforce meaning when helpful"
                ]
            )
        }
    }
    
    // Card showcase
    var cardShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Info Card", code: "BFInfoCard(title: \"Title\", icon: \"icon\") { content }") {
                BFInfoCard(title: "Daily Tip", icon: "lightbulb.fill") {
                    Text("Regular mindfulness practice can help reduce gambling urges by 65%.")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            componentSection(title: "Stats Card", code: "BFStatsCard(title: \"Title\", stats: [...])") {
                BFStatsCard(title: "Your Progress", stats: [
                    ("Streak", "7 days"),
                    ("Saved", "$240"),
                    ("Mindful", "42 min")
                ])
            }
            
            usage(
                title: "Card Usage Guidelines",
                guidelines: [
                    "Use Info Cards to display tips, information, or explanations",
                    "Use Stats Cards to display multiple related statistics",
                    "Keep content concise and scannable",
                    "Group related information together",
                    "Maintain consistent spacing within cards"
                ]
            )
        }
    }
    
    // Input showcase
    var inputShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Text Field", code: "BFTextField(placeholder: \"Label\", text: $text)") {
                VStack(spacing: BFSpacing.medium) {
                    BFTextField(placeholder: "Standard Text Field", text: $sampleText)
                    BFTextField(placeholder: "With Icon", icon: "envelope", text: $sampleText)
                    BFTextField(placeholder: "Password Field", icon: "lock", text: $sampleText, isSecure: true)
                }
            }
            
            usage(
                title: "Input Usage Guidelines",
                guidelines: [
                    "Use clear, concise placeholder text",
                    "Include icons that represent the field's purpose",
                    "Group related fields together",
                    "Validate input and provide clear error messages",
                    "Use secure fields for sensitive information"
                ]
            )
        }
    }
    
    // List showcase
    var listShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "List Item", code: "BFListItem(title: \"Title\", subtitle: \"Subtitle\", icon: \"icon\", action: {})") {
                VStack(spacing: BFSpacing.medium) {
                    BFListItem(
                        title: "Standard Item",
                        subtitle: "Description of the item",
                        icon: "heart.fill",
                        action: {}
                    )
                    
                    BFListItem(
                        title: "Premium Feature",
                        subtitle: "Only available to subscribers",
                        icon: "star.fill",
                        isLocked: true,
                        action: {}
                    )
                    
                    BFListItem(
                        title: "Custom Color",
                        subtitle: "Using a different icon color",
                        icon: "bell.fill",
                        iconColor: BFColors.warning,
                        action: {}
                    )
                }
            }
            
            componentSection(title: "Empty State", code: "BFEmptyState(title: \"Title\", message: \"Message\", icon: \"icon\")") {
                BFEmptyState(
                    title: "No Items Found",
                    message: "Items you add will appear here.",
                    icon: "tray",
                    buttonTitle: "Add Item",
                    action: {}
                )
            }
            
            usage(
                title: "List Usage Guidelines",
                guidelines: [
                    "Use consistent list items throughout the app",
                    "Include icons that represent the item's purpose",
                    "Keep subtitles concise and informative",
                    "Always provide empty states for when lists have no items",
                    "Use isLocked for premium features"
                ]
            )
        }
    }
    
    // Indicator showcase
    var indicatorShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Progress Bar", code: "BFProgressBar(value: 0.7, label: \"Label\")") {
                VStack(spacing: BFSpacing.medium) {
                    BFProgressBar(value: sampleProgress, label: "With Label")
                    BFProgressBar(value: sampleProgress * 0.5)
                    
                    Slider(value: $sampleProgress, in: 0...1)
                        .tint(BFColors.accent)
                }
            }
            
            componentSection(title: "Badge", code: "BFBadge(text: \"Label\", type: .type)") {
                VStack(spacing: BFSpacing.medium) {
                    HStack {
                        BFBadge(text: "Success", type: .success)
                        BFBadge(text: "Warning", type: .warning)
                        BFBadge(text: "Error", type: .error)
                    }
                    
                    HStack {
                        BFBadge(text: "Info", type: .info)
                        BFBadge(text: "Premium", type: .premium)
                    }
                }
            }
            
            usage(
                title: "Indicator Usage Guidelines",
                guidelines: [
                    "Use Progress Bars to show completion status",
                    "Use Badges to indicate status or category",
                    "Choose appropriate badge types based on semantics",
                    "Keep badge text short (1-2 words)",
                    "Use consistent indicator styles throughout the app"
                ]
            )
        }
    }
    
    // Screen showcase
    var screenShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Standard Screens", code: "BFScreenContainer, BFListScreen, BFDetailScreen, etc.") {
                VStack(spacing: BFSpacing.medium) {
                    Image("screen_templates")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(BFCornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                                .stroke(BFColors.divider, lineWidth: 1)
                        )
                    
                    Text("The app includes several standardized screen templates in BFStandardizedScreens.swift")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            usage(
                title: "Screen Usage Guidelines",
                guidelines: [
                    "Use BFScreenContainer as the base for most screens",
                    "Use BFListScreen for displaying collections of items",
                    "Use BFDetailScreen for item details with header and footer",
                    "Use BFFormScreen for input forms",
                    "Use BFDashboardScreen for home/dashboard screens"
                ]
            )
            
            NavigationLink(destination: ScreenCatalogView()) {
                Text("View Full Screen Catalog")
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.accent)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                            .stroke(BFColors.accent, lineWidth: 1)
                    )
            }
        }
    }
    
    // Animation showcase
    var animationShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            @State var isAnimating = false
            
            Button("Toggle Animations") {
                withAnimation {
                    isAnimating.toggle()
                }
            }
            .font(BFTypography.button)
            .foregroundColor(BFColors.accent)
            .padding(.bottom, BFSpacing.medium)
            
            componentSection(title: "Fade Animation", code: ".fadeInAnimation(isActive: bool)") {
                Text("Fade In Animation")
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textPrimary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(BFColors.cardBackground)
                    .cornerRadius(BFCornerRadius.medium)
                    .fadeInAnimation(isActive: isAnimating)
            }
            
            componentSection(title: "Slide Animation", code: ".slideInAnimation(isActive: bool, from: .edge)") {
                HStack {
                    Text("Slide From Leading")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(BFColors.cardBackground)
                        .cornerRadius(BFCornerRadius.medium)
                        .slideInAnimation(isActive: isAnimating, from: .leading)
                    
                    Text("Slide From Trailing")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(BFColors.cardBackground)
                        .cornerRadius(BFCornerRadius.medium)
                        .slideInAnimation(isActive: isAnimating, from: .trailing)
                }
            }
            
            componentSection(title: "Scale Animation", code: ".scaleAnimation(isActive: bool)") {
                Text("Scale Animation")
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textPrimary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(BFColors.cardBackground)
                    .cornerRadius(BFCornerRadius.medium)
                    .scaleAnimation(isActive: isAnimating)
            }
            
            usage(
                title: "Animation Usage Guidelines",
                guidelines: [
                    "Use .fadeInAnimation for subtle entrance animations",
                    "Use .slideInAnimation for directional movement",
                    "Use .scaleAnimation for emphasis",
                    "Always check accessibility settings with .accessibleAnimation",
                    "Keep animations subtle and purposeful"
                ]
            )
        }
    }
    
    // Typography showcase
    var typographyShowcase: some View {
        VStack(alignment: .leading, spacing: BFSpacing.large) {
            componentSection(title: "Headings", code: ".font(BFTypography.headingX)") {
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Heading 1 - 32pt Bold")
                        .font(BFTypography.heading1)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text("Heading 2 - 24pt Semibold")
                        .font(BFTypography.heading2)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text("Heading 3 - 20pt Medium")
                        .font(BFTypography.heading3)
                        .foregroundColor(BFColors.textPrimary)
                }
            }
            
            componentSection(title: "Body Text", code: ".font(BFTypography.bodyX)") {
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Body Large - 18pt Regular")
                        .font(BFTypography.bodyLarge)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text("Body Medium - 16pt Regular")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text("Body Small - 14pt Regular")
                        .font(BFTypography.bodySmall)
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            
            componentSection(title: "UI Elements", code: ".font(BFTypography.X)") {
                VStack(alignment: .leading, spacing: BFSpacing.small) {
                    Text("Button - 16pt Medium")
                        .font(BFTypography.button)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text("Caption - 12pt Regular")
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.textTertiary)
                    
                    Text("OVERLINE - 10PT MEDIUM CAPS")
                        .font(BFTypography.overline)
                        .foregroundColor(BFColors.textTertiary)
                }
            }
            
            usage(
                title: "Typography Usage Guidelines",
                guidelines: [
                    "Use heading styles for section titles",
                    "Use body styles for main content",
                    "Match text importance to visual hierarchy",
                    "Use semantic colors with typography",
                    "Respect dynamic type settings"
                ]
            )
        }
    }
    
    // Color showcase
    var colorShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Primary Colors", code: "BFColors.X") {
                HStack(spacing: BFSpacing.medium) {
                    colorSwatch("Primary", color: BFColors.primary)
                    colorSwatch("Secondary", color: BFColors.secondary)
                    colorSwatch("Accent", color: BFColors.accent)
                }
            }
            
            componentSection(title: "Theme Colors", code: "BFColors.X") {
                HStack(spacing: BFSpacing.medium) {
                    colorSwatch("Calm", color: BFColors.calm)
                    colorSwatch("Focus", color: BFColors.focus)
                    colorSwatch("Hope", color: BFColors.hope)
                }
            }
            
            componentSection(title: "Functional Colors", code: "BFColors.X") {
                HStack(spacing: BFSpacing.medium) {
                    colorSwatch("Success", color: BFColors.success)
                    colorSwatch("Warning", color: BFColors.warning)
                    colorSwatch("Error", color: BFColors.error)
                }
            }
            
            componentSection(title: "Text Colors", code: "BFColors.textX") {
                HStack(spacing: BFSpacing.medium) {
                    colorSwatch("Primary", color: BFColors.textPrimary)
                    colorSwatch("Secondary", color: BFColors.textSecondary)
                    colorSwatch("Tertiary", color: BFColors.textTertiary)
                }
            }
            
            componentSection(title: "Background Colors", code: "BFColors.X") {
                HStack(spacing: BFSpacing.medium) {
                    colorSwatch("Background", color: BFColors.background)
                    colorSwatch("Secondary", color: BFColors.secondaryBackground)
                    colorSwatch("Card", color: BFColors.cardBackground)
                }
            }
            
            usage(
                title: "Color Usage Guidelines",
                guidelines: [
                    "Use BFColors instead of direct Color objects",
                    "Follow semantic meaning (e.g., error for errors)",
                    "Maintain proper contrast for accessibility",
                    "Use .bfWhite instead of Color.white",
                    "Use .bfGray() instead of Color.gray"
                ]
            )
        }
    }
    
    // Spacing showcase
    var spacingShowcase: some View {
        VStack(spacing: BFSpacing.large) {
            componentSection(title: "Standard Spacing", code: "BFSpacing.X") {
                VStack(alignment: .leading, spacing: BFSpacing.medium) {
                    spacingExample("Tiny", size: BFSpacing.tiny)
                    spacingExample("Small", size: BFSpacing.small)
                    spacingExample("Medium", size: BFSpacing.medium)
                    spacingExample("Large", size: BFSpacing.large)
                    spacingExample("X-Large", size: BFSpacing.xlarge)
                    spacingExample("XX-Large", size: BFSpacing.xxlarge)
                }
            }
            
            componentSection(title: "Screen Spacing", code: "BFSpacing.screenX") {
                VStack(alignment: .leading, spacing: BFSpacing.medium) {
                    spacingExample("Screen Horizontal", size: BFSpacing.screenHorizontal)
                    spacingExample("Screen Vertical", size: BFSpacing.screenVertical)
                    spacingExample("Card Padding", size: BFSpacing.cardPadding)
                }
            }
            
            usage(
                title: "Spacing Usage Guidelines",
                guidelines: [
                    "Use BFSpacing constants for all spacing values",
                    "Apply consistent spacing between related elements",
                    "Use standardContentSpacing() for content containers",
                    "Use standardSectionSpacing() for section separation",
                    "Match spacing to information hierarchy"
                ]
            )
        }
    }
}

// MARK: - Helper Views

extension BFComponentShowcase {
    // Component section with title, code example, and content
    private func componentSection<Content: View>(title: String, code: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: BFSpacing.small) {
            Text(title)
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(BFColors.info)
                .padding(BFSpacing.small)
                .background(BFColors.info.opacity(0.1))
                .cornerRadius(BFCornerRadius.small)
            
            content()
                .padding(BFSpacing.medium)
                .standardCardBackground()
        }
    }
    
    // Usage guidelines
    private func usage(title: String, guidelines: [String]) -> some View {
        VStack(alignment: .leading, spacing: BFSpacing.small) {
            Text(title)
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            VStack(alignment: .leading, spacing: BFSpacing.tiny) {
                ForEach(guidelines, id: \.self) { guideline in
                    HStack(alignment: .top, spacing: BFSpacing.small) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BFColors.success)
                            .font(.caption)
                        
                        Text(guideline)
                            .font(BFTypography.bodySmall)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
            }
            .padding(BFSpacing.medium)
            .background(BFColors.cardBackground.opacity(0.7))
            .cornerRadius(BFCornerRadius.medium)
        }
    }
    
    // Color swatch
    private func colorSwatch(_ name: String, color: Color) -> some View {
        VStack(spacing: BFSpacing.tiny) {
            Circle()
                .fill(color)
                .frame(width: 60, height: 60)
                .shadow(color: Color.bfShadow(opacity: 0.1), radius: 4, x: 0, y: 2)
            
            Text(name)
                .font(BFTypography.caption)
                .foregroundColor(BFColors.textSecondary)
        }
    }
    
    // Spacing example
    private func spacingExample(_ name: String, size: CGFloat) -> some View {
        HStack(spacing: BFSpacing.medium) {
            Text(name)
                .font(BFTypography.bodyMedium)
                .foregroundColor(BFColors.textPrimary)
                .frame(width: 120, alignment: .leading)
            
            Text("\(Int(size))pt")
                .font(BFTypography.bodySmall)
                .foregroundColor(BFColors.textSecondary)
                .frame(width: 50, alignment: .leading)
            
            Rectangle()
                .fill(BFColors.accent)
                .frame(width: size, height: 20)
        }
    }
}

// MARK: - Screen Catalog

struct ScreenCatalogView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: BFSpacing.large) {
                Text("Screen Templates")
                    .font(BFTypography.heading2)
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.top, BFSpacing.large)
                
                Text("These standardized screen templates are available in BFStandardizedScreens.swift")
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFSpacing.screenHorizontal)
                
                // Screen examples
                Group {
                    screenExample(
                        title: "BFScreenContainer",
                        description: "Base container for most screens with standard header and back button.",
                        code: """
                        BFScreenContainer(title: "Screen Title") {
                            // Your content here
                        }
                        """
                    )
                    
                    screenExample(
                        title: "BFListScreen",
                        description: "Display lists of items with empty state handling.",
                        code: """
                        BFListScreen(
                            title: "List Title",
                            items: yourItems,
                            emptyContent: {
                                // Empty state
                            }
                        ) { item in
                            // Item view
                        }
                        """
                    )
                    
                    screenExample(
                        title: "BFDetailScreen",
                        description: "Detail view with header, scrollable content, and footer.",
                        code: """
                        BFDetailScreen(
                            title: "Detail Title",
                            headerContent: {
                                // Header view
                            },
                            content: {
                                // Main content
                            },
                            footerContent: {
                                // Footer actions
                            }
                        )
                        """
                    )
                    
                    screenExample(
                        title: "BFFormScreen",
                        description: "Input form with keyboard avoidance and action buttons.",
                        code: """
                        BFFormScreen(
                            title: "Form Title",
                            content: {
                                // Form fields
                            },
                            footerContent: {
                                // Action buttons
                            }
                        )
                        """
                    )
                    
                    screenExample(
                        title: "BFDashboardScreen",
                        description: "Dashboard layout with header stats and scrollable content.",
                        code: """
                        BFDashboardScreen(
                            title: "Dashboard",
                            headerContent: {
                                // User info and stats
                            },
                            content: {
                                // Dashboard content
                            }
                        )
                        """
                    )
                }
            }
            .padding(.horizontal, BFSpacing.screenHorizontal)
            .padding(.bottom, BFSpacing.xlarge)
        }
        .navigationTitle("Screen Templates")
        .background(BFColors.background.edgesIgnoringSafeArea(.all))
    }
    
    private func screenExample(title: String, description: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: BFSpacing.medium) {
            Text(title)
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            Text(description)
                .font(BFTypography.bodyMedium)
                .foregroundColor(BFColors.textSecondary)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(BFColors.info)
                .padding(BFSpacing.small)
                .background(BFColors.info.opacity(0.1))
                .cornerRadius(BFCornerRadius.small)
        }
        .padding(BFSpacing.medium)
        .standardCardBackground()
    }
}

// MARK: - Helper Types

enum ComponentSection: String, CaseIterable {
    case buttons = "Buttons"
    case cards = "Cards"
    case inputs = "Inputs"
    case lists = "Lists"
    case indicators = "Indicators"
    case screens = "Screens"
    case animations = "Animations"
    case typography = "Typography"
    case colors = "Colors"
    case spacing = "Spacing"
    
    var title: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .buttons:
            return "Standardized buttons for primary and secondary actions."
        case .cards:
            return "Card containers for displaying related information."
        case .inputs:
            return "Input controls for collecting user data."
        case .lists:
            return "Components for displaying lists of items."
        case .indicators:
            return "Visual indicators for status and progress."
        case .screens:
            return "Screen templates for consistent layouts."
        case .animations:
            return "Standard animations for UI elements."
        case .typography:
            return "Text styles for consistent typography."
        case .colors:
            return "Color system for consistent branding."
        case .spacing:
            return "Spacing system for consistent layout."
        }
    }
}

// MARK: - Preview Provider

struct BFComponentShowcase_Previews: PreviewProvider {
    static var previews: some View {
        BFComponentShowcase()
    }
} 