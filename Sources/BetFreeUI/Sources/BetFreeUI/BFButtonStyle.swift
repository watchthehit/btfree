import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct BFPrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
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
            .font(.body)
            .foregroundColor(BFDesignSystem.Colors.primary)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.white)
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

@available(macOS 11.0, *)
public struct BFButtonStyle: ButtonStyle {
    public init() {}
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        if #available(macOS 12.0, *) {
            configuration.label
                .font(.body)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.white)
                .cornerRadius(BFDesignSystem.Radius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                        .stroke(BFDesignSystem.Colors.primary, lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        } else {
            configuration.label
                .font(.body)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                        .stroke(BFDesignSystem.Colors.primary, lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

@available(macOS 11.0, *)
extension ButtonStyle where Self == BFButtonStyle {
    public static var bf: BFButtonStyle {
        BFButtonStyle()
    }
}
