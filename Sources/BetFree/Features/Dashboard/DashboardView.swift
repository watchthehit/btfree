import SwiftUI
import ComposableArchitecture

public struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingTransactionSheet = false
    @State private var transactionAmount = ""
    @State private var transactionNote = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let coreDataManager = CoreDataManager.shared
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                    // Header with Streak and Savings
                    HeaderStatsView(streak: appState.streak, savings: appState.savings)
                    
                    // Daily Progress Card
                    DailyProgressCard(
                        dailyLimit: appState.dailyLimit,
                        currentSpend: coreDataManager.getTotalSpentToday()
                    )
                    .onTapGesture {
                        showingTransactionSheet = true
                    }
                    
                    // Today's Transactions
                    TransactionsListView(transactions: coreDataManager.getTodaysTransactions())
                    
                    // Motivation Section
                    MotivationSection()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .background(BFDesignSystem.Colors.background)
            .sheet(isPresented: $showingTransactionSheet) {
                AddTransactionSheet(
                    isPresented: $showingTransactionSheet,
                    amount: $transactionAmount,
                    note: $transactionNote,
                    onSave: addTransaction
                )
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addTransaction() {
        guard let amount = Double(transactionAmount) else {
            errorMessage = "Please enter a valid amount"
            showingError = true
            return
        }
        
        do {
            try coreDataManager.addTransaction(amount: amount, note: transactionNote)
            transactionAmount = ""
            transactionNote = ""
            showingTransactionSheet = false
        } catch {
            errorMessage = "Failed to save transaction: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    public init() {}
}

// MARK: - Add Transaction Sheet
private struct AddTransactionSheet: View {
    @Binding var isPresented: Bool
    @Binding var amount: String
    @Binding var note: String
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Note (optional)", text: $note)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    onSave()
                }
            )
        }
    }
}

// MARK: - Transactions List View
private struct TransactionsListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Today's Transactions")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            if transactions.isEmpty {
                Text("No transactions today")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(transactions, id: \.id) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
        .withShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

private struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.note ?? "No note")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(transaction.date?.formatted(date: .omitted, time: .shortened) ?? "")
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(BFDesignSystem.Typography.bodyLargeMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Header Stats View
private struct HeaderStatsView: View {
    let streak: Int
    let savings: Double
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Streak Card
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                HStack(alignment: .top, spacing: 4) {
                    Text("\(streak)")
                        .font(BFDesignSystem.Typography.titleLarge)
                    Text("days")
                        .font(BFDesignSystem.Typography.caption)
                        .padding(.top, 4)
                }
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                
                Text("Current Streak")
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .withShadow(BFDesignSystem.Layout.Shadow.small)
            
            // Savings Card
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text("$\(savings, specifier: "%.0f")")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundStyle(BFDesignSystem.Colors.mindfulGradient)
                
                Text("Total Savings")
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .withShadow(BFDesignSystem.Layout.Shadow.small)
        }
    }
}

// MARK: - Daily Progress Card
private struct DailyProgressCard: View {
    let dailyLimit: Double
    let currentSpend: Double
    
    var progress: Double {
        guard dailyLimit > 0 else { return 0 }
        return min(currentSpend / dailyLimit, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Daily Progress")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(BFDesignSystem.Colors.separator)
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(progress > 0.8 ? BFDesignSystem.Colors.error : BFDesignSystem.Colors.success)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            // Stats
            HStack {
                VStack(alignment: .leading) {
                    Text("Spent")
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    Text("$\(currentSpend, specifier: "%.2f")")
                        .font(BFDesignSystem.Typography.bodyLargeMedium)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Limit")
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    Text("$\(dailyLimit, specifier: "%.2f")")
                        .font(BFDesignSystem.Typography.bodyLargeMedium)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                }
            }
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
        .withShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

// MARK: - Motivation Section
private struct MotivationSection: View {
    let quotes = [
        "Every day is a new opportunity to stay strong.",
        "Progress is progress, no matter how small.",
        "You are stronger than you think.",
        "Focus on the day ahead, not the mistakes behind.",
        "Your future self will thank you."
    ]
    
    var randomQuote: String {
        quotes.randomElement() ?? quotes[0]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Daily Motivation")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(randomQuote)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(BFDesignSystem.Colors.cardBackground)
                .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
} 