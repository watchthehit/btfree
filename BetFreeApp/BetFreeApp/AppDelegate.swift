import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Reset splash screen for testing
        #if DEBUG
        UserDefaults.standard.set(false, forKey: "hasShownSplash")
        print("Reset splash screen for testing")
        #endif
        
        return true
    }
} 