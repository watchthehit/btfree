import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct BFPrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFDesignSystem.bodyMediumFont)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(isEnabled ? BFDesignSystem.primaryColor : BFDesignSystem.primaryColor.opacity(0.5))
            .cornerRadius(BFDesignSystem.cornerRadiusMedium)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 10.15, iOS 13.0, *)
public struct BFSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFDesignSystem.bodyMediumFont)
            .foregroundColor(BFDesignSystem.primaryColor)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(BFDesignSystem.surfaceColor)
            .cornerRadius(BFDesignSystem.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BFDesignSystem.cornerRadiusMedium)
                    .stroke(BFDesignSystem.primaryColor, lineWidth: BFDesignSystem.borderWidthThin)
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
