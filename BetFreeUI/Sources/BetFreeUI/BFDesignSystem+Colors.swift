import SwiftUI

@available(macOS 13.0, iOS 16.0, *)
public extension BFDesignSystem {
    enum Colors {
        public static let primary = Color.blue
        public static let success = Color.green
        public static let warning = Color.yellow
        public static let error = Color.red
        
        #if os(iOS)
        public static let textPrimary = Color(uiColor: .label)
        public static let textSecondary = Color(uiColor: .secondaryLabel)
        public static let border = Color(uiColor: .separator)
        public static let background = Color(uiColor: .systemBackground)
        public static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
        public static let cardBackground = Color(uiColor: .systemBackground)
        #else
        public static let textPrimary = Color.primary
        public static let textSecondary = Color.secondary
        public static let border = Color.gray.opacity(0.2)
        public static let background = Color.white
        public static let secondaryBackground = Color.white.opacity(0.8)
        public static let cardBackground = Color.white
        #endif
        
        public static let warmGradient = LinearGradient(
            colors: [
                Color.orange,
                Color.red
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        public static let calmingGradient = LinearGradient(
            colors: [
                Color.blue,
                Color.purple
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        public static let mindfulGradient = LinearGradient(
            colors: [
                Color.green,
                Color.blue
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        public static let primaryGradient = LinearGradient(
            colors: [
                primary,
                primary.opacity(0.8)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
} 