import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct BFPrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFDesignSystem.Typography.bodyMedium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(isEnabled ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.primary.opacity(0.5))
            .cornerRadius(BFDesignSystem.Radius.medium)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 10.15, iOS 13.0, *)
public struct BFSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFDesignSystem.Typography.bodyMedium)
            .foregroundColor(BFDesignSystem.Colors.primary)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(.background)
            .cornerRadius(BFDesignSystem.Radius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                    .stroke(BFDesignSystem.Colors.primary, lineWidth: BFDesignSystem.borderWidthThin)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 10.15, iOS 13.0, *)
public extension Button {
    func bfPrimaryButtonStyle() -> some View {
        self.buttonStyle(BFPrimaryButtonStyle())
    }
    
    func bfSecondaryButtonStyle() -> some View {
        self.buttonStyle(BFSecondaryButtonStyle())
    }
}
