import Foundation

public enum BFConfig {
    private static let environment = ProcessInfo.processInfo.environment
    
    public static var apiKey: String {
        #if DEBUG
        return environment["BF_API_KEY"] ?? "debug_api_key"
        #else
        guard let key = environment["BF_API_KEY"] else {
            fatalError("API key not found in environment. Set BF_API_KEY in your environment variables.")
        }
        return key
        #endif
    }
    
    public static var apiBaseURL: String {
        #if DEBUG
        return environment["BF_API_URL"] ?? "https://api-staging.betfree.app/v1"
        #else
        return environment["BF_API_URL"] ?? "https://api.betfree.app/v1"
        #endif
    }
    
    public static var shouldValidateReceipts: Bool {
        #if DEBUG
        return environment["BF_VALIDATE_RECEIPTS"] != "0"
        #else
        return true
        #endif
    }
    
    public static var subscriptionProducts: [BFSubscriptionProduct] {
        #if DEBUG
        return BFSubscriptionProduct.allCases
        #else
        return BFSubscriptionProduct.allCases.filter { !$0.id.contains("test") }
        #endif
    }
} 