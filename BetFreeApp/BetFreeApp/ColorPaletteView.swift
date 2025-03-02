import SwiftUI

/**
 * ColorPaletteView - A view that displays the "Serene Recovery" color scheme
 *
 * This view displays all the colors in the "Serene Recovery" color scheme and can be
 * used as a reference by designers and developers.
 */
struct ColorPaletteView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Serene Recovery")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(BFColors.textPrimary)
                        .padding(.top, 20)
                    
                    Text("Color Scheme Overview")
                        .font(.subheadline)
                        .foregroundColor(BFColors.textSecondary)
                        .padding(.bottom, 16)
                    
                    // Primary Colors
                    colorSection(
                        title: "Primary Colors",
                        description: "The main colors of the Serene Recovery theme",
                        colors: [
                            ColorInfo(name: "Primary (Deep Teal)", color: BFColors.primary, hex: "#2A6B7C"),
                            ColorInfo(name: "Secondary (Soft Sage)", color: BFColors.secondary, hex: "#89B399"),
                            ColorInfo(name: "Accent (Sunset Orange)", color: BFColors.accent, hex: "#E67E53")
                        ]
                    )
                    
                    // Theme Colors
                    colorSection(
                        title: "Theme Colors",
                        description: "Specialized colors for different emotional states",
                        colors: [
                            ColorInfo(name: "Calm Teal", color: BFColors.calm, hex: "#4A8D9D"),
                            ColorInfo(name: "Focus Sage", color: BFColors.focus, hex: "#769C86"),
                            ColorInfo(name: "Hope (Warm Sand)", color: BFColors.hope, hex: "#E6C9A8")
                        ]
                    )
                    
                    // Functional Colors
                    colorSection(
                        title: "Functional Colors",
                        description: "Colors for status and feedback",
                        colors: [
                            ColorInfo(name: "Success Green", color: BFColors.success, hex: "#4CAF50"),
                            ColorInfo(name: "Warning Amber", color: BFColors.warning, hex: "#FF9800"),
                            ColorInfo(name: "Error Red", color: BFColors.error, hex: "#F44336")
                        ]
                    )
                    
                    // Neutral Colors
                    colorSection(
                        title: "Neutral Colors",
                        description: "Background and text colors with dark mode variants",
                        colors: [
                            ColorInfo(name: "Background", color: BFColors.background, hex: "#F7F3EB"),
                            ColorInfo(name: "Card Background", color: BFColors.cardBackground, hex: "#FFFFFF"),
                            ColorInfo(name: "Text Primary", color: BFColors.textPrimary, hex: "#2D3142"),
                            ColorInfo(name: "Text Secondary", color: BFColors.textSecondary, hex: "#5C6079"),
                            ColorInfo(name: "Text Tertiary", color: BFColors.textTertiary, hex: "#767B91"),
                            ColorInfo(name: "Divider", color: BFColors.divider, hex: "#E1E2E8")
                        ]
                    )
                    
                    // Gradients
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Gradients")
                            .font(.headline)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("Predefined gradients for UI enhancement")
                            .font(.subheadline)
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.bottom, 8)
                        
                        gradientItem(name: "Primary Gradient", gradient: BFColors.primaryGradient())
                        gradientItem(name: "Brand Gradient", gradient: BFColors.brandGradient())
                        gradientItem(name: "Energy Gradient", gradient: BFColors.energyGradient())
                        gradientItem(name: "Progress Gradient", gradient: BFColors.progressGradient())
                    }
                    .padding()
                    .background(BFColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    // Usage Notes
                    BFCard(title: "Color Usage Guidelines") {
                        VStack(alignment: .leading, spacing: 12) {
                            usageGuidelineRow(
                                icon: "paintbrush.fill",
                                title: "Primary Buttons",
                                description: "Use Deep Teal with white text"
                            )
                            
                            usageGuidelineRow(
                                icon: "paintbrush.pointed.fill",
                                title: "Secondary Buttons",
                                description: "Use Soft Sage with dark text"
                            )
                            
                            usageGuidelineRow(
                                icon: "exclamationmark.triangle.fill",
                                title: "Accent Color",
                                description: "Use Sunset Orange sparingly for important actions"
                            )
                            
                            usageGuidelineRow(
                                icon: "checkmark.circle.fill",
                                title: "Success States",
                                description: "Use Success Green with supportive messaging"
                            )
                            
                            usageGuidelineRow(
                                icon: "xmark.circle.fill",
                                title: "Error States",
                                description: "Use Error Red with descriptive message"
                            )
                        }
                    }
                }
                .padding()
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("Color Palette")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Helper Views
    
    private func colorSection(title: String, description: String, colors: [ColorInfo]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(BFColors.textPrimary)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(BFColors.textSecondary)
                .padding(.bottom, 8)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(colors) { colorInfo in
                    colorItem(colorInfo: colorInfo)
                }
            }
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func colorItem(colorInfo: ColorInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorInfo.color)
                .frame(height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(BFColors.divider, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(colorInfo.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(colorInfo.hex)
                    .font(.caption2)
                    .foregroundColor(BFColors.textSecondary)
            }
        }
    }
    
    private func gradientItem(name: String, gradient: LinearGradient) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(BFColors.textPrimary)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(gradient)
                .frame(height: 50)
        }
    }
    
    private func usageGuidelineRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(BFColors.primary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Helper Models

struct ColorInfo: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let hex: String
}

// MARK: - Preview

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView()
            .preferredColorScheme(.light)
        
        ColorPaletteView()
            .preferredColorScheme(.dark)
    }
} 