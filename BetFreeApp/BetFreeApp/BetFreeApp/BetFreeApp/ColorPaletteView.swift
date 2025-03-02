import SwiftUI

/**
 * ColorPaletteView - A view that displays the "Serene Strength" color scheme
 *
 * This view displays all the colors in the "Serene Strength" color scheme and can be
 * used as a reference by designers and developers.
 */
struct ColorPaletteView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Serene Strength")
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
                        description: "The main colors of the Serene Strength theme",
                        colors: [
                            ColorInfo(name: "Primary (Deep Space Blue)", color: BFColors.primary, hex: "#0D1B2A"),
                            ColorInfo(name: "Secondary (Vibrant Teal)", color: BFColors.secondary, hex: "#64FFDA"),
                            ColorInfo(name: "Accent (Coral)", color: BFColors.accent, hex: "#FF7043")
                        ]
                    )
                    
                    // Theme Colors
                    colorSection(
                        title: "Theme Colors",
                        description: "Specialized colors for different emotional states",
                        colors: [
                            ColorInfo(name: "Calm (Ocean Blue)", color: BFColors.calm, hex: "#415A77"),
                            ColorInfo(name: "Focus (Aquamarine)", color: BFColors.focus, hex: "#00B4D8"),
                            ColorInfo(name: "Hope (Warm Sand)", color: BFColors.hope, hex: "#E0E1DD")
                        ]
                    )
                    
                    // Additional Colors 
                    colorSection(
                        title: "Additional Theme Colors",
                        description: "Supplementary colors for specific contexts",
                        colors: [
                            ColorInfo(name: "Healing (Teal Green)", color: BFColors.healing, hex: "#26A69A"),
                            ColorInfo(name: "Info (Deep Blue)", color: BFColors.info, hex: "#0077B6")
                        ]
                    )
                    
                    // Functional Colors
                    colorSection(
                        title: "Functional Colors",
                        description: "Colors that indicate specific states and functions",
                        colors: [
                            ColorInfo(name: "Success", color: BFColors.success, hex: "#4CAF50"),
                            ColorInfo(name: "Warning", color: BFColors.warning, hex: "#FF9800"),
                            ColorInfo(name: "Error", color: BFColors.error, hex: "#F44336")
                        ]
                    )
                    
                    // Neutral Colors - Light Mode
                    colorSection(
                        title: "Neutral Colors (Light Mode)",
                        description: "Base colors for backgrounds and text in light mode",
                        colors: [
                            ColorInfo(name: "Background (Light Silver)", 
                                    color: Color(hex: "#E0E1DD"), 
                                    hex: "#E0E1DD"),
                            ColorInfo(name: "Card Background (White)", 
                                    color: Color(hex: "#FFFFFF"), 
                                    hex: "#FFFFFF"),
                            ColorInfo(name: "Text Primary (Deep Space)", 
                                    color: Color(hex: "#0D1B2A"), 
                                    hex: "#0D1B2A"),
                            ColorInfo(name: "Text Secondary (Navy)", 
                                    color: Color(hex: "#1B263B"), 
                                    hex: "#1B263B")
                        ]
                    )
                    
                    // Neutral Colors - Dark Mode
                    colorSection(
                        title: "Neutral Colors (Dark Mode)",
                        description: "Base colors for backgrounds and text in dark mode",
                        colors: [
                            ColorInfo(name: "Background (Deep Space)", 
                                    color: Color(hex: "#0D1B2A"), 
                                    hex: "#0D1B2A"),
                            ColorInfo(name: "Card Background (Navy)", 
                                    color: Color(hex: "#263F60"), 
                                    hex: "#263F60"),
                            ColorInfo(name: "Text Primary (Silver)", 
                                    color: Color(hex: "#E0E1DD"), 
                                    hex: "#E0E1DD"),
                            ColorInfo(name: "Text Secondary (Light Silver)", 
                                    color: Color(hex: "#CCD1D9"), 
                                    hex: "#CCD1D9")
                        ]
                    )
                    
                    // Gradients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gradients")
                            .font(.headline)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("Predefined gradients for UI enhancement")
                            .font(.subheadline)
                            .foregroundColor(BFColors.textSecondary)
                            .padding(.bottom, 8)
                        
                        gradientItem(name: "Primary Gradient", gradient: BFColors.primaryGradient())
                        gradientItem(name: "Calm Gradient", gradient: BFColors.calmGradient())
                        gradientItem(name: "Energy Gradient", gradient: BFColors.energyGradient())
                        gradientItem(name: "Progress Gradient", gradient: BFColors.progressGradient())
                    }
                    .padding()
                    .background(BFColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    
                    // Usage Notes
                    BFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Color Usage Guidelines")
                                .font(.headline)
                                .foregroundColor(BFColors.textPrimary)
                                .padding(.bottom, 8)
                                
                            usageGuidelineRow(
                                icon: "paintbrush.fill",
                                title: "Primary Buttons",
                                description: "Use Deep Space Blue with white text"
                            )
                            
                            usageGuidelineRow(
                                icon: "paintbrush.pointed.fill",
                                title: "Secondary Buttons",
                                description: "Use Vibrant Teal with dark text"
                            )
                            
                            usageGuidelineRow(
                                icon: "exclamationmark.triangle.fill",
                                title: "Accent Color",
                                description: "Use Coral sparingly for important actions"
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