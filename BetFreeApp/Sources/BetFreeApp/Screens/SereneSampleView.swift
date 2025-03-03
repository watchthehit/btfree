import SwiftUI

/**
 * A sample view that showcases the Serene Recovery design system components.
 * This view provides a visual catalog and interactive demonstration
 * of these components.
 */
@available(iOS 15.0, macOS 12.0, *)
public struct SereneSampleView: View {
    @State private var showDetails = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    colorPalette
                    buttonSection
                    cardSection
                }
                .padding()
            }
            .background(BFColors.background.ignoresSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showDetails) {
                detailView
            }
        }
    }
    
    // MARK: - Subviews
    
    private var colorPalette: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Palette")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(BFColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                colorItem(name: "Primary", color: BFColors.primary)
                colorItem(name: "Secondary", color: BFColors.secondary)
                colorItem(name: "Error", color: BFColors.error)
                colorItem(name: "Text Primary", color: BFColors.textPrimary)
                colorItem(name: "Text Secondary", color: BFColors.textSecondary)
                colorItem(name: "Background", color: BFColors.background)
            }
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func colorItem(name: String, color: Color) -> some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 48)
            
            Text(name)
                .font(.caption)
                .foregroundColor(BFColors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
    
    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buttons")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(BFColors.textPrimary)
            
            VStack(spacing: 12) {
                BFButton("Primary Button", style: .primary) {}
                BFButton("Secondary Button", style: .secondary) {}
                BFButton("Tertiary Button", style: .tertiary) {}
                BFButton("Destructive Button", style: .destructive) {}
                BFButton("Disabled Button", isEnabled: false) {}
            }
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var cardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cards")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(BFColors.textPrimary)
            
            VStack(spacing: 16) {
                BFCard(title: "Recovery Progress", subtitle: "Last 7 days") {
                    Text("Card content")
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
                }
                
                BFCard(title: "Mindfulness Exercise", accentColor: BFColors.calm) {
                    Text("Breathing exercise content")
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
                }
                
                BFCard(title: "Daily Challenge", subtitle: "Complete for rewards", footer: "Tap to start") {
                    Text("Challenge content")
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
                }
            }
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var detailView: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Color Meanings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(BFColors.textPrimary)
                
                VStack(spacing: 16) {
                    meaningRow(color: BFColors.primary, name: "Primary", meaning: "Trust, stability, and professionalism")
                    meaningRow(color: BFColors.secondary, name: "Secondary", meaning: "Support, growth, and harmony")
                    meaningRow(color: BFColors.error, name: "Error", meaning: "Attention, warning, and critical actions")
                }
                .padding(.bottom, 32)
            }
            .background(BFColors.background.ignoresSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        showDetails = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(BFColors.textTertiary)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
    
    private func meaningRow(color: Color, name: String, meaning: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(meaning)
                    .font(.subheadline)
                    .foregroundColor(BFColors.textSecondary)
            }
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, *)
struct SereneSampleView_Previews: PreviewProvider {
    static var previews: some View {
        SereneSampleView()
    }
} 