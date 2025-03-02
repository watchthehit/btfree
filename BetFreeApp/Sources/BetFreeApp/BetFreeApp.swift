import SwiftUI

/**
 * BetFreeApp - Main app entry point
 *
 * This file provides the main app structure and entry point for the BetFree app.
 * It uses the "Serene Recovery" color scheme components.
 */
@main
public struct BetFreeApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            SereneSampleView()
        }
    }
} 