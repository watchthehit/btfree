import Foundation
import StoreKit

public protocol BFSubscriptionService {
    func verifyReceipt(_ receipt: String) async throws -> ReceiptValidationResponse
    func verifyTrialEligibility(_ receipt: String) async throws -> Bool
    func validateSubscription(_ transaction: StoreKit.Transaction) async throws -> Bool
}

public struct ReceiptValidationResponse: Codable {
    let isValid: Bool
    let expirationDate: Date?
    let isTrialPeriod: Bool
    let productId: String?
    let originalTransactionId: String?
}

actor BFSubscriptionServiceImpl: BFSubscriptionService {
    private let baseURL: String
    private let apiKey: String
    private let shouldValidateReceipts: Bool
    
    init() {
        self.baseURL = BFConfig.apiBaseURL
        self.apiKey = BFConfig.apiKey
        self.shouldValidateReceipts = BFConfig.shouldValidateReceipts
    }
    
    func verifyReceipt(_ receipt: String) async throws -> ReceiptValidationResponse {
        #if DEBUG
        if !shouldValidateReceipts {
            return ReceiptValidationResponse(
                isValid: true,
                expirationDate: Date().addingTimeInterval(86400 * 30),
                isTrialPeriod: true,
                productId: BFSubscriptionProduct.monthly.id,
                originalTransactionId: "test_transaction"
            )
        }
        #endif
        
        var request = URLRequest(url: URL(string: "\(baseURL)/verify-receipt")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body = ["receipt": receipt]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BFStoreError.verification
        }
        
        return try JSONDecoder().decode(ReceiptValidationResponse.self, from: data)
    }
    
    func verifyTrialEligibility(_ receipt: String) async throws -> Bool {
        #if DEBUG
        if !shouldValidateReceipts {
            return true
        }
        #endif
        
        var request = URLRequest(url: URL(string: "\(baseURL)/verify-trial")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body = ["receipt": receipt]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BFStoreError.verification
        }
        
        struct Response: Codable {
            let isEligible: Bool
        }
        
        let result = try JSONDecoder().decode(Response.self, from: data)
        return result.isEligible
    }
    
    func validateSubscription(_ transaction: StoreKit.Transaction) async throws -> Bool {
        #if DEBUG
        if !shouldValidateReceipts {
            return true
        }
        #endif
        
        var request = URLRequest(url: URL(string: "\(baseURL)/validate-subscription")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let originalId = String(transaction.originalID)
        
        let body: [String: Any] = [
            "transactionId": String(transaction.id),
            "productId": transaction.productID,
            "originalTransactionId": originalId,
            "purchaseDate": transaction.purchaseDate.ISO8601Format(),
            "expirationDate": transaction.expirationDate?.ISO8601Format() ?? ""
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BFStoreError.verification
        }
        
        struct Response: Codable {
            let isValid: Bool
        }
        
        let result = try JSONDecoder().decode(Response.self, from: data)
        return result.isValid
    }
} 