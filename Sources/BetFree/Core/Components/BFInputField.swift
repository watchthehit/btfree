import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public enum BFKeyboardType {
    case `default`
    case asciiCapable
    case decimalPad
    
    #if canImport(UIKit)
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .asciiCapable:
            return .asciiCapable
        case .decimalPad:
            return .decimalPad
        }
    }
    #endif
}

public struct BFInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let prefix: String?
    let keyboardType: BFKeyboardType
    
    public init(title: String, text: Binding<String>, placeholder: String, prefix: String? = nil, keyboardType: BFKeyboardType = .default) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.prefix = prefix
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            
            HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                if let prefix = prefix {
                    Text(prefix)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                TextField(placeholder, text: $text)
                    #if canImport(UIKit)
                    .keyboardType(keyboardType.uiKeyboardType)
                    #endif
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(BFDesignSystem.Typography.bodyLarge)
            }
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
    }
} 