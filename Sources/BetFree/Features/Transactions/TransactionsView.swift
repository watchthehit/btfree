import SwiftUI
import BetFreeUI
import BetFreeModels

public struct TransactionsView: View {
    @State private var transactions: [BetFreeModels.Transaction] = []
    @State private var isLoading = false
    @State private var showingAddTransaction = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                } else {
                    if transactions.isEmpty {
                        EmptyStateView()
                    } else {
                        TransactionListView(transactions: transactions)
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .onAppear {
                Task {
                    do {
                        try await loadTransactions()
                    } catch {
                        print("Error loading transactions: \(error)")
                    }
                }
            }
            .refreshable {
                await loadTransactionsWithErrorHandling()
            }
        }
    }
    
    @MainActor
    private func loadTransactionsWithErrorHandling() async {
        do {
            try await loadTransactions()
        } catch {
            print("Error refreshing transactions: \(error)")
        }
    }
    
    @MainActor
    private func loadTransactions() async throws {
        isLoading = true
        defer { isLoading = false }
        
        let manager = MockCDManager.shared
        self.transactions = manager.getAllTransactions()
    }
    
    @MainActor
    private func deleteTransaction(_ transaction: BetFreeModels.Transaction) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let manager = MockCDManager.shared
        try manager.deleteTransaction(transaction)
        try await loadTransactions()
    }
}

private struct TransactionRowView: View {
    let transaction: BetFreeModels.Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transaction.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(transaction.category.rawValue)
                        .font(BFDesignSystem.Typography.titleSmall)
                    
                    if let note = transaction.note {
                        Text(note)
                            .font(BFDesignSystem.Typography.bodySmall)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                Text(formatAmount(transaction.amount))
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(transaction.amount > 0 ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.error)
            }
            
            Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
}