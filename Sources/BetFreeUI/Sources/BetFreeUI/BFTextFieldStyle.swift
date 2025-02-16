import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct BFTextFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(BFDesignSystem.bodyMediumFont)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.cornerRadiusMedium)
                    .fill(BFDesignSystem.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFDesignSystem.cornerRadiusMedium)
                            .stroke(BFDesignSystem.borderColor, lineWidth: BFDesignSystem.borderWidthThin)
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
