import SwiftUI

@available(macOS 13.0, iOS 16.0, *)
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
            .background(isEnabled ? Color.blue : Color.blue.opacity(0.5))
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 13.0, iOS 16.0, *)
public struct BFSecondaryButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 13.0, iOS 16.0, *)
public extension Button {
    func bfPrimaryButtonStyle() -> some View {
        self.buttonStyle(BFPrimaryButtonStyle())
    }
    
    func bfSecondaryButtonStyle() -> some View {
        self.buttonStyle(BFSecondaryButtonStyle())
    }
}

@available(macOS 13.0, iOS 16.0, *)
public struct BFOutlineButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 13.0, iOS 16.0, *)
public struct BFPlainButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

@available(macOS 13.0, iOS 16.0, *)
public struct BFButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(Color.blue)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension ButtonStyle where Self == BFButtonStyle {
    public static var bf: BFButtonStyle {
        BFButtonStyle()
    }
}
