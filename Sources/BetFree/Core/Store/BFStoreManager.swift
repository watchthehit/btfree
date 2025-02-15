import Foundation
import StoreKit

@MainActor
public class BFStoreManager: ObservableObject {
    public static let shared = BFStoreManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var subscriptionStatus: BFUserState = .expired
    
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Product Loading
    
    public func loadProducts() async {
        do {
            let products = try await Product.products(for: BFSubscriptionProduct.allCases.map(\.id))
            self.products = products.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    // MARK: - Purchase Flow
    
    public func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction
            
        case .userCancelled:
            return nil
            
        case .pending:
            throw BFStoreError.pending
            
        @unknown default:
            throw BFStoreError.unknown
        }
    }
    
    public func restorePurchases() async throws {
        try await AppStore.sync()
        await updateSubscriptionStatus()
    }
    
    // MARK: - Subscription Status
    
    public func checkTrialEligibility() async throws -> Bool {
        // Check if user has had a trial before
        guard let receipt = await getReceipt() else {
            return true // No receipt means never had trial
        }
        
        // Verify with server
        return try await verifyTrialEligibility(receipt: receipt)
    }
    
    private func updateSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else {
                continue
            }
            
            if transaction.revocationDate == nil {
                // Active subscription
                purchasedProductIDs.insert(transaction.productID)
                
                let expirationDate = transaction.expirationDate ?? .distantFuture
                if transaction.isUpgraded {
                    continue
                }
                
                if let offerType = transaction.offerType {
                    switch offerType {
                    case .introductory:
                        subscriptionStatus = .trial(endDate: expirationDate)
                    default:
                        subscriptionStatus = .subscribed(expiryDate: expirationDate)
                    }
                } else {
                    subscriptionStatus = .subscribed(expiryDate: expirationDate)
                }
                return
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        subscriptionStatus = .expired
    }
    
    // MARK: - Transaction Listener
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                guard let transaction = try? self.checkVerified(result) else {
                    continue
                }
                
                await transaction.finish()
                await self.updateSubscriptionStatus()
            }
        }
    }
    
    // MARK: - Receipt Validation
    
    private func getReceipt() async -> String? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            return nil
        }
        
        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL)
            return receiptData.base64EncodedString()
        } catch {
            print("Failed to read receipt: \(error)")
            return nil
        }
    }
    
    private func verifyTrialEligibility(receipt: String) async throws -> Bool {
        // TODO: Implement server-side validation
        // For now, just check local UserDefaults
        return !UserDefaults.standard.bool(forKey: "BF_HAS_HAD_TRIAL")
    }
    
    // MARK: - Helper Methods
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw BFStoreError.verification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Models

public enum BFSubscriptionProduct: String, CaseIterable {
    case monthly = "com.betfree.subscription.monthly"
    case yearly = "com.betfree.subscription.yearly"
    
    var id: String { rawValue }
    var period: String {
        switch self {
        case .monthly: return "month"
        case .yearly: return "year"
        }
    }
}

public enum BFUserState: Equatable {
    case trial(endDate: Date)
    case subscribed(expiryDate: Date)
    case expired
    case needsRestore
}

public enum BFStoreError: LocalizedError {
    case verification
    case pending
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .verification:
            return "Receipt verification failed"
        case .pending:
            return "Purchase is pending"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
