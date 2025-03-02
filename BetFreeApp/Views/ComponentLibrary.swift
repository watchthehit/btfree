import SwiftUI

/**
 * ComponentLibrary
 * A showcase of all BetFree UI components and illustrations
 * Use this for development and design reference
 */
struct ComponentLibrary: View {
    @State private var selectedSection = 0
    private let sections = ["Buttons", "Cards", "Illustrations", "Typography", "Colors"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section picker
                Picker("Component Section", selection: $selectedSection) {
                    ForEach(0..<sections.count, id: \.self) { index in
                        Text(sections[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Component display
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        switch selectedSection {
                        case 0:
                            buttonsSection
                        case 1:
                            cardsSection
                        case 2:
                            illustrationsSection
                        case 3:
                            typographySection
                        case 4:
                            colorsSection
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("BetFree Components")
            .background(BFColors.adaptiveBackground(for: colorScheme))
        }
    }
    
    // MARK: - Buttons Section
    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Buttons")
            
            Group {
                componentCard("Primary Button") {
                    BFButton(
                        title: "Continue",
                        style: .primary,
                        action: {}
                    )
                }
                
                componentCard("Primary Button with Icon") {
                    BFButton(
                        title: "Save Progress",
                        style: .primary,
                        icon: "arrow.down.doc.fill",
                        action: {},
                        isFullWidth: true
                    )
                }
                
                componentCard("Secondary Button") {
                    BFButton(
                        title: "Learn More",
                        style: .secondary,
                        action: {}
                    )
                }
                
                componentCard("Text Button") {
                    BFButton(
                        title: "Skip for now",
                        style: .text,
                        action: {}
                    )
                }
                
                componentCard("Disabled Button") {
                    BFButton(
                        title: "Not Available",
                        style: .primary,
                        action: {},
                        isDisabled: true
                    )
                }
            }
        }
    }
    
    // MARK: - Cards Section
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Cards")
            
            Group {
                componentCard("Standard Card") {
                    BFCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Standard Card")
                                .font(.headline)
                            Text("Basic content container for most screens")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                componentCard("Elevated Card") {
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Elevated Card")
                                .font(.headline)
                            Text("Stands out with shadow to draw attention")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                componentCard("Outlined Card") {
                    BFCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Outlined Card")
                                .font(.headline)
                            Text("Lighter container with border instead of background")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                componentCard("Interactive Card") {
                    BFCard(style: .interactive, action: {}) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interactive Card")
                                    .font(.headline)
                                Text("Tappable card for navigation")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(BFColors.oceanBlue)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Illustrations Section
    private var illustrationsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Illustrations")
            
            Group {
                componentCard("Breaking Free") {
                    BFOnboardingIllustrations.BreakingFree(size: 150)
                }
                
                componentCard("Growth Journey") {
                    BFOnboardingIllustrations.GrowthJourney(size: 150)
                }
                
                componentCard("Calm Mind") {
                    BFOnboardingIllustrations.CalmMind(size: 150)
                }
                
                componentCard("Support Network") {
                    BFOnboardingIllustrations.SupportNetwork(size: 150)
                }
                
                componentCard("App Logo") {
                    VStack(spacing: 24) {
                        BetFreeLogo(style: .full, size: 100)
                        
                        HStack(spacing: 40) {
                            VStack {
                                BetFreeLogo(style: .compact, size: 60)
                                Text("Compact")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                BetFreeLogo(style: .horizontal, size: 40)
                                Text("Horizontal")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    // MARK: - Typography Section
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Typography")
            
            componentCard("Headings") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Heading 1")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Heading 2")
                        .font(.system(size: 22, weight: .bold))
                    
                    Text("Heading 3")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            
            componentCard("Body Text") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Body")
                        .font(.system(size: 16, weight: .regular))
                    
                    Text("Caption")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Text("Small/Legal")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
            
            componentCard("Interactive Text") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Button Text")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Link Text")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(BFColors.oceanBlue)
                    
                    Text("Navigation Text")
                        .font(.system(size: 14, weight: .medium))
                }
            }
        }
    }
    
    // MARK: - Colors Section
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Colors")
            
            componentCard("Primary Colors") {
                VStack(spacing: 12) {
                    colorSwatch("Deep Space Blue", color: BFColors.deepSpaceBlue)
                    colorSwatch("Oxford Blue", color: BFColors.oxfordBlue)
                    colorSwatch("Vibrant Teal", color: BFColors.vibrantTeal)
                    colorSwatch("Ocean Blue", color: BFColors.oceanBlue)
                    colorSwatch("Coral", color: BFColors.coral)
                }
            }
            
            componentCard("Text Colors") {
                VStack(spacing: 12) {
                    colorSwatch("Text Primary", color: BFColors.textPrimary)
                    colorSwatch("Text Secondary", color: BFColors.textSecondary)
                    colorSwatch("Text Tertiary", color: BFColors.textTertiary)
                }
            }
            
            componentCard("Functional Colors") {
                VStack(spacing: 12) {
                    colorSwatch("Success", color: BFColors.success)
                    colorSwatch("Warning", color: BFColors.warning)
                    colorSwatch("Error", color: BFColors.error)
                    colorSwatch("Neutral", color: BFColors.neutral)
                }
            }
            
            componentCard("Gradients") {
                VStack(spacing: 20) {
                    gradientSwatch("Brand Gradient", gradient: BFColors.brandGradient())
                    gradientSwatch("Dark Gradient", gradient: BFColors.darkGradient())
                    gradientSwatch("Energy Gradient", gradient: BFColors.energyGradient())
                }
            }
        }
    }
    
    // MARK: - Helper Components
    
    @ViewBuilder
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private func componentCard<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            content()
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? BFColors.oxfordBlue.opacity(0.5) : Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                )
        }
    }
    
    @ViewBuilder
    private func colorSwatch(_ name: String, color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 60, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func gradientSwatch(_ name: String, gradient: LinearGradient) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.subheadline)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(gradient)
                .frame(height: 50)
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
}

// MARK: - Preview
struct ComponentLibrary_Previews: PreviewProvider {
    static var previews: some View {
        ComponentLibrary()
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
        
        ComponentLibrary()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
} 