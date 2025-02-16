import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct BFTextFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(BFDesignSystem.Typography.bodyMedium)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                    .fill(.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                            .stroke(BFDesignSystem.Colors.border, lineWidth: BFDesignSystem.borderWidthThin)
                    )
            )
    }
}

@available(macOS 10.15, iOS 13.0, *)
public extension View {
    func bfTextFieldStyle() -> some View {
        self.textFieldStyle(BFTextFieldStyle())
    }
}
