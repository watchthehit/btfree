import SwiftUI

// MARK: - Feature Comparison Row
struct BFFeatureRow: View {
    let title: String
    let isPremium: Bool
    let isAvailable: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Status indicator
            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isAvailable ? BFColors.success : BFColors.textTertiary)
                .font(.system(size: 18))
            
            // Feature name
            Text(title)
                .font(BFTypography.bodyMedium)
                .foregroundColor(BFColors.textPrimary)
            
            Spacer()
            
            // Premium badge (if applicable)
            if isPremium {
                Text("PRO")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(BFColors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Plan Selection Card
struct BFPlanSelectionCard: View {
    let title: String
    let price: String
    let billingPeriod: String
    let isPopular: Bool
    let savings: String?
    @Binding var selectedPlan: Int
    let planIndex: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Popular badge
            if isPopular {
                Text("MOST POPULAR")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(BFColors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .offset(y: -12)
            }
            
            // Card content
            VStack(spacing: 8) {
                Text(title)
                    .font(BFTypography.heading3)
                
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(price)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(BFColors.primary)
                    
                    Text(billingPeriod)
                        .font(BFTypography.bodySmall)
                        .foregroundColor(BFColors.textSecondary)
                }
                
                if let savingsText = savings {
                    Text(savingsText)
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.success)
                        .padding(.top, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == planIndex ? BFColors.primary : BFColors.textTertiary.opacity(0.3), lineWidth: selectedPlan == planIndex ? 2 : 1)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedPlan == planIndex ? BFColors.primary.opacity(0.05) : Color.white)
                    )
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    selectedPlan = planIndex
                }
            }
        }
    }
}

// MARK: - Timed Progress Bar
struct BFTimedProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let daysRemaining: Int
    
    var body: some View {
        VStack(spacing: 6) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(BFColors.textTertiary.opacity(0.3))
                        .frame(height: 8)
                    
                    // Fill
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.primary]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            // Days remaining text
            HStack {
                Text("\(daysRemaining) days remaining")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
                
                Spacer()
                
                Text("Free Trial")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.accent)
            }
        }
    }
}

// MARK: - Feature List Section
struct BFFeatureListSection: View {
    let title: String
    let features: [(String, Bool, Bool)] // (title, isPremium, isAvailable)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(BFTypography.heading3)
                .padding(.top, 4)
            
            ForEach(features, id: \.0) { feature in
                BFFeatureRow(title: feature.0, isPremium: feature.1, isAvailable: feature.2)
            }
        }
    }
} 