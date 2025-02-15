import SwiftUI

public struct BFStatCard: View {
    let value: String
    let label: String
    let icon: String?
    let gradient: LinearGradient?
    
    public init(
        value: String,
        label: String,
        icon: String? = nil,
        gradient: LinearGradient? = nil
    ) {
        self.value = value
        self.label = label
        self.icon = icon
        self.gradient = gradient
    }
    
    public var body: some View {
        BFCard(style: .default, gradient: gradient) {
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(gradient == nil ? BFDesignSystem.Colors.primary : .white)
                }
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(gradient == nil ? BFDesignSystem.Colors.primary : .white)
                
                Text(label)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(gradient == nil ? BFDesignSystem.Colors.textSecondary : .white.opacity(0.8))
            }
            .multilineTextAlignment(.center)
        }
    }
}

public extension LinearGradient {
    static let orangeGradient = LinearGradient(
        colors: [Color.orange.opacity(0.8), Color.orange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let greenGradient = LinearGradient(
        colors: [Color.green.opacity(0.8), Color.green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [Color.blue.opacity(0.8), Color.blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let purpleGradient = LinearGradient(
        colors: [Color.purple.opacity(0.8), Color.purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}