import Foundation
import StoreKit
import BetFreeModels

public struct Plan: Identifiable {
    public let id: Int
    public let title: String
    public let description: String
    public let price: String
    
    public init(id: Int, title: String, description: String, price: String) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
    }
}

@MainActor
public final class PaywallViewModel: ObservableObject {
    @Published private(set) var purchaseSuccessful = false
    @Published private(set) var error: Error?
    
    private let storeManager: BFStoreManager
    private let dataManager: BetFreeDataManager
    
    public init(dataManager: BetFreeDataManager) {
        self.dataManager = dataManager
        // Access shared on MainActor
        self.storeManager = BFStoreManager.shared
    }
    
    public func purchase(plan: Plan) async {
        do {
            // Get the corresponding StoreKit product
            let productId = plan.id == 1 ? BFSubscriptionProduct.monthly.id : BFSubscriptionProduct.yearly.id
            
            // Since we're in @MainActor context, we can safely access shared
            guard let product = storeManager.products.first(where: { $0.id == productId }) else {
                throw BFStoreError.unknown
            }
            
            // Attempt the purchase
            if try await storeManager.purchase(product) != nil {
                // Create user profile if it doesn't exist
                if dataManager.getCurrentUser() == nil {
                    try dataManager.createOrUpdateUser(
                        name: "New User",
                        email: nil,
                        dailyLimit: 0.0
                    )
                }
                
                purchaseSuccessful = true
            }
        } catch {
            self.error = error
            purchaseSuccessful = false
        }
    }
} 