import SwiftUI
import UIKit

// This class provides functions to fix the empty tab bar space issue
// by modifying global UITabBar appearance
class FixTabBarSpaceHelper {
    
    // Call this function at app startup
    static func hideEmptyTabBarSpace() {
        // Hide tab bar globally
        UITabBar.appearance().isHidden = true
        
        // For iOS 15+, configure transparent tab bar appearances
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = nil
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Remove tab bar extra spacing
        DispatchQueue.main.async {
            removeTabBarExtraSpacing()
        }
    }
    
    // This function attempts to find and modify the tab bar controller to remove extra spacing
    private static func removeTabBarExtraSpacing() {
        // Get the main window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        // Function to recursively search for tab bar controllers
        func findTabBarController(in viewController: UIViewController) -> UITabBarController? {
            if let tabBarController = viewController as? UITabBarController {
                return tabBarController
            }
            
            if let navigationController = viewController as? UINavigationController {
                if let tabBarController = navigationController.viewControllers.first as? UITabBarController {
                    return tabBarController
                }
            }
            
            for child in viewController.children {
                if let found = findTabBarController(in: child) {
                    return found
                }
            }
            
            return nil
        }
        
        // Modify tab bar if found
        if let tabBarController = findTabBarController(in: rootViewController) {
            // Hide tab bar
            tabBarController.tabBar.isHidden = true
            
            // Remove bottom insets that might be causing the empty space
            tabBarController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -49, right: 0)
        }
    }
}

// SwiftUI modifier to ensure the view extends to the bottom of the screen
struct RemoveTabBarSpaceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 0)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                FixTabBarSpaceHelper.hideEmptyTabBarSpace()
            }
    }
}

extension View {
    func removeTabBarSpace() -> some View {
        self.modifier(RemoveTabBarSpaceModifier())
    }
} 