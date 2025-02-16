import Foundation
import StoreKit

@MainActor
public class BFStoreManager: ObservableObject {
    public static let shared = BFStoreManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var subscriptionStatus: BFUserState = .expired
    
    private var transactionListener: Task<Void, Error>?
    
    private init() {
        // Start listening for transactions
        transactionListener = Task.detached {
            await self.listenForTransactions()
        }
        
        // Load initial state
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
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
    
    public func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction
            
        case .userCancelled, .pending:
            return nil
            
        default:
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
        var hasActiveSubscription = false
        
        // Get all transactions
        for await verification in StoreKit.Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(verification) else {
                continue
            }
            
            // Check if the transaction is still valid
            if transaction.revocationDate == nil && !transaction.isUpgraded {
                // Active subscription
                purchasedProductIDs.insert(transaction.productID)
                
                let expirationDate = transaction.expirationDate ?? .distantFuture
                
                // Check subscription status
                if transaction.productType == .autoRenewable {
                    hasActiveSubscription = true
                    if let product = products.first(where: { $0.id == transaction.productID }),
                       product.subscription?.introductoryOffer != nil {
                        subscriptionStatus = .trial(endDate: expirationDate)
                    } else {
                        subscriptionStatus = .subscribed(expiryDate: expirationDate)
                    }
                }
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        if !hasActiveSubscription {
            subscriptionStatus = .expired
        }
    }
    
    // MARK: - Transaction Listener
    
    private func listenForTransactions() async {
        for await verification in StoreKit.Transaction.updates {
            guard let transaction = try? checkVerified(verification) else {
                continue
            }
            
            await transaction.finish()
            await updateSubscriptionStatus()
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

public enum BFUserState: Codable, Equatable {
    case trial(endDate: Date)
    case subscribed(expiryDate: Date)
    case expired
    case needsRestore
    
    private enum CodingKeys: String, CodingKey {
        case type, endDate, expiryDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(Int.self, forKey: .type)
        
        switch type {
        case 1:
            let endDate = try container.decode(Date.self, forKey: .endDate)
            self = .trial(endDate: endDate)
        case 2:
            let expiryDate = try container.decode(Date.self, forKey: .expiryDate)
            self = .subscribed(expiryDate: expiryDate)
        case 3:
            self = .expired
        case 4:
            self = .needsRestore
        default:
            self = .expired
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .trial(let endDate):
            try container.encode(1, forKey: .type)
            try container.encode(endDate, forKey: .endDate)
        case .subscribed(let expiryDate):
            try container.encode(2, forKey: .type)
            try container.encode(expiryDate, forKey: .expiryDate)
        case .expired:
            try container.encode(3, forKey: .type)
        case .needsRestore:
            try container.encode(4, forKey: .type)
        }
    }
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
