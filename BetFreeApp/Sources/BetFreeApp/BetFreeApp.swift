import SwiftUI

/**
 * The main app entry point for BetFreeApp.
 * It uses the "Serene Recovery" color scheme components.
 */
@available(iOS 15.0, macOS 12.0, *)
@main
public struct BetFreeApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            SereneSampleView()
        }
    }
} 