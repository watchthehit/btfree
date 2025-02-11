import SwiftUI

public enum BFDesignSystem {
    public enum Colors {
        public static let primary = Color.blue
        public static let secondary = Color.purple
        public static let accent = Color.orange
        public static let success = Color.green
        public static let info = Color.blue
        public static let warning = Color.yellow
        public static let error = Color.red
        
        public static let textPrimary = Color.primary
        public static let textSecondary = Color.secondary
        public static let separator = Color.gray.opacity(0.2)
        
        public static let cardBackground = Color.white
        public static let background = Color.gray.opacity(0.1)
        
        public static let calmingGradient = LinearGradient(
            colors: [primary, accent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let warmGradient = LinearGradient(
            colors: [warning, error],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let mindfulGradient = LinearGradient(
            colors: [info, success],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let primaryGradient = LinearGradient(
            colors: [primary, primary.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public enum Typography {
        public static let display = Font.system(size: 32, weight: .bold)
        public static let titleLarge = Font.system(size: 28, weight: .bold)
        public static let titleMedium = Font.system(size: 24, weight: .bold)
        public static let titleSmall = Font.system(size: 20, weight: .semibold)
        public static let headlineMedium = Font.system(size: 22, weight: .semibold)
        
        public static let bodyLarge = Font.system(size: 18)
        public static let bodyLargeMedium = Font.system(size: 18, weight: .medium)
        public static let bodyMedium = Font.system(size: 16)
        public static let bodySmall = Font.system(size: 14)
        
        public static let button = Font.system(size: 16, weight: .medium)
        public static let caption = Font.system(size: 12)
    }
    
    public enum Layout {
        public enum Spacing {
            public static let xxSmall: CGFloat = 4
            public static let xSmall: CGFloat = 8
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 24
            public static let xLarge: CGFloat = 32
            public static let xxLarge: CGFloat = 48
        }
        
        public enum CornerRadius {
            public static let small: CGFloat = 8
            public static let medium: CGFloat = 12
            public static let large: CGFloat = 16
            public static let xLarge: CGFloat = 24
            public static let card: CGFloat = 20
            public static let button: CGFloat = 12
        }
        
        public enum Shadow {
            public static let small = ViewShadow(radius: 4, y: 2)
            public static let medium = ViewShadow(radius: 8, y: 4)
            public static let large = ViewShadow(radius: 16, y: 8)
            public static let card = ViewShadow(radius: 8, y: 4)
            public static let button = ViewShadow(radius: 6, y: 3)
        }
        
        public enum Size {
            public static let iconSmall: CGFloat = 16
            public static let iconMedium: CGFloat = 20
            public static let iconLarge: CGFloat = 24
            public static let iconXLarge: CGFloat = 32
            
            public static let buttonHeight: CGFloat = 48
            public static let progressCircleLarge: CGFloat = 80
        }
    }
}

public struct ViewShadow {
    let radius: CGFloat
    let y: CGFloat
    
    public init(radius: CGFloat, y: CGFloat) {
        self.radius = radius
        self.y = y
    }
}

public extension View {
    func withShadow(_ shadow: ViewShadow) -> some View {
        self.shadow(radius: shadow.radius, y: shadow.y)
    }
} 