import SwiftUI
import BetFreeUI
#if canImport(UIKit)
import UIKit
#endif

public struct BFTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: BFKeyboardType = .default
    var prefix: String?
    
    public init(
        title: String,
        text: Binding<String>,
        placeholder: String,
        keyboardType: BFKeyboardType = .default,
        prefix: String? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.prefix = prefix
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            
            HStack(spacing: 8) {
                if let prefix = prefix {
                    Text(prefix)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                TextField(placeholder, text: $text)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .textFieldStyle(.plain)
                    #if canImport(UIKit)
                    .keyboardType(keyboardType.uiKeyboardType)
                    #endif
            }
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(BFDesignSystem.Colors.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
        BFTextField(
            title: "Name",
            text: Binding.constant(""),
            placeholder: "Enter your name"
        )
        
        BFTextField(
            title: "Amount",
            text: Binding.constant(""),
            placeholder: "Enter amount",
            keyboardType: .decimalPad,
            prefix: "$"
        )
    }
    .padding()
} 