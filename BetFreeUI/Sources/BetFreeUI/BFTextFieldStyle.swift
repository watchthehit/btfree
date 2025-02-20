import SwiftUI

@available(macOS 13.0, iOS 16.0, *)
public struct BFTextFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(Font.body)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
    }
}

@available(macOS 13.0, iOS 16.0, *)
public extension View {
    func bfTextFieldStyle() -> some View {
        self.textFieldStyle(BFTextFieldStyle())
    }
}
