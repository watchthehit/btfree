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
            Group {
                if isLoading {
                    VStack {
                        Spacer()
                        SwiftUI.ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5)
                        Spacer()
                    }
                } else if transactions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Text("No Transactions")
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        Text("Add a transaction to get started")
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        Spacer()
                    }
                } else {
                    List(transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteTransaction(transaction)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                    await loadTransactions()
                }
            }
            .refreshable {
                await loadTransactions()
            }
        }
    }
    
    private func loadTransactions() async {
        do {
            await MainActor.run {
                isLoading = true
            }
            
            let manager = MockCDManager.shared
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let fetchedTransactions = try await manager.getAllTransactions().map(\.transaction)
            
            await MainActor.run {
                self.transactions = fetchedTransactions
                self.isLoading = false
            }
        } catch {
            print("Error loading transactions: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func deleteTransaction(_ transaction: BetFreeModels.Transaction) {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                }
                
                let manager = MockCDManager.shared
                try await Task.sleep(nanoseconds: 1_000_000_000)  // Simulate network delay
                try await manager.deleteTransaction(transaction)
                await loadTransactions()
            } catch {
                print("Error deleting transaction: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
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