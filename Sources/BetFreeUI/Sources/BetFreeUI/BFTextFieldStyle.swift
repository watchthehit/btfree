import SwiftUI

@available(macOS 11.0, *)
public struct BFTextFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        if #available(macOS 12.0, *) {
            configuration
                .font(Font.body)
                .textFieldStyle(.plain)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
        } else {
            configuration
                .font(Font.body)
                .textFieldStyle(.plain)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: BFDesignSystem.Radius.medium)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

@available(macOS 11.0, *)
public extension View {
    func bfTextFieldStyle() -> some View {
        self.textFieldStyle(BFTextFieldStyle())
    }
}
