import SwiftUI

/// Color constants used throughout the app
@available(iOS 15.0, macOS 12.0, *)
public enum BFColors {
    /// Primary brand color
    public static let primary = Color("Primary", bundle: .module)
    
    /// Secondary brand color
    public static let secondary = Color("Secondary", bundle: .module)
    
    /// Error/destructive color
    public static let error = Color("Error", bundle: .module)
    
    /// Primary text color
    public static let textPrimary = Color("TextPrimary", bundle: .module)
    
    /// Secondary text color
    public static let textSecondary = Color("TextSecondary", bundle: .module)
    
    /// Tertiary text color
    public static let textTertiary = Color("TextSecondary", bundle: .module).opacity(0.6)
    
    /// Background color
    public static let background = Color("Background", bundle: .module)
    
    /// Surface color for cards and elevated surfaces
    public static let surface = Color("Surface", bundle: .module)
    
    /// Card background color
    public static let cardBackground = Color("Surface", bundle: .module)
    
    /// Divider color
    public static let divider = Color("TextSecondary", bundle: .module).opacity(0.1)
    
    /// Calm color for mindfulness features
    public static let calm = Color("Primary", bundle: .module).opacity(0.8)
} 