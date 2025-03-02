import SwiftUI

/**
 * SereneSampleView - A sample view showcasing the "Serene Recovery" color scheme components
 *
 * This view demonstrates the use of the BFButton and BFCard components with the
 * "Serene Recovery" color scheme. It can be used to test the appearance and behavior
 * of these components.
 */
public struct SereneSampleView: View {
    @State private var showDetails = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Serene Recovery")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(BFColors.textPrimary)
                        .padding(.top, 20)
                    
                    Text("Color Scheme Components")
                        .font(.subheadline)
                        .foregroundColor(BFColors.textSecondary)
                        .padding(.bottom, 16)
                    
                    // Colors section
                    colorPalette
                    
                    // Buttons section
                    buttonSection
                    
                    // Cards section
                    cardSection
                }
                .padding()
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .sheet(isPresented: $showDetails) {
                detailView
            }
        }
    }
    
    // MARK: - Subviews
    
    private var colorPalette: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Palette")
                .font(.headline)
                .foregroundColor(BFColors.textPrimary)
            
            HStack(spacing: 16) {
                colorItem(name: "Primary", color: BFColors.primary)
                colorItem(name: "Secondary", color: BFColors.secondary)
                colorItem(name: "Accent", color: BFColors.accent)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                colorItem(name: "Calm", color: BFColors.calm)
                colorItem(name: "Focus", color: BFColors.focus)
                colorItem(name: "Hope", color: BFColors.hope)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                colorItem(name: "Success", color: BFColors.success)
                colorItem(name: "Warning", color: BFColors.warning)
                colorItem(name: "Error", color: BFColors.error)
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
                .frame(width: 70, height: 50)
            
            Text(name)
                .font(.caption)
                .foregroundColor(BFColors.textSecondary)
        }
    }
    
    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buttons")
                .font(.headline)
                .foregroundColor(BFColors.textPrimary)
            
            BFButton("Primary Button", style: .primary) {}
            
            BFButton("Secondary Button", style: .secondary) {}
            
            BFButton("Tertiary Button", style: .tertiary) {}
            
            BFButton("Destructive", style: .destructive) {}
            
            BFButton("With Icon", icon: Image(systemName: "star.fill")) {}
            
            BFButton("Learn More", style: .tertiary, icon: Image(systemName: "arrow.right"), iconPosition: .trailing) {
                showDetails = true
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
                .font(.headline)
                .foregroundColor(BFColors.textPrimary)
            
            BFCard(title: "Standard Card", subtitle: "With subtitle") {
                Text("This is a standard card with a title and subtitle. It can contain any content you want.")
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.vertical, 8)
            }
            
            BFCard(title: "Card with Accent", accentColor: BFColors.primary) {
                Text("This card has an accent color at the top.")
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.vertical, 8)
            }
            
            BFCard(title: "Selectable Card", isSelectable: true, action: {
                showDetails = true
            }) {
                HStack {
                    Text("Tap this card to see details")
                        .foregroundColor(BFColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(BFColors.textTertiary)
                }
                .padding(.vertical, 8)
            }
            
            BFCard(footer: "Last updated: Today") {
                Text("This card has a footer.")
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.vertical, 8)
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
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFColors.primary)
                    .padding(.top, 40)
                
                Text("Serene Recovery")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(BFColors.textPrimary)
                
                Text("This color scheme is designed to create a calming, supportive environment for users on their recovery journey.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(BFColors.textSecondary)
                    .padding(.horizontal)
                
                BFCard(title: "Color Meaning", accentColor: BFColors.accent) {
                    VStack(alignment: .leading, spacing: 12) {
                        meaningRow(color: BFColors.primary, name: "Deep Teal", meaning: "Stability and calm")
                        meaningRow(color: BFColors.secondary, name: "Soft Sage", meaning: "Growth and healing")
                        meaningRow(color: BFColors.accent, name: "Sunset Orange", meaning: "Energy and encouragement")
                        meaningRow(color: BFColors.calm, name: "Calm Teal", meaning: "Relaxation and peace")
                        meaningRow(color: BFColors.focus, name: "Focus Sage", meaning: "Concentration and clarity")
                        meaningRow(color: BFColors.hope, name: "Warm Sand", meaning: "Comfort and safety")
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                BFButton("Close", action: {
                    showDetails = false
                })
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(BFColors.background.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: Button(action: {
                showDetails = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(BFColors.textTertiary)
                    .font(.system(size: 24))
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func meaningRow(color: Color, name: String, meaning: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(meaning)
                    .font(.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

struct SereneSampleView_Previews: PreviewProvider {
    static var previews: some View {
        SereneSampleView()
    }
} 