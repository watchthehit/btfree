import SwiftUI
import ComposableArchitecture
import BetFreeModels
import BetFreeUI
#if canImport(UIKit)
import UIKit
#endif

struct DashboardHeaderView: View {
    @ObservedObject var appState: AppState
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Welcome Message with Animation
            Text("Welcome back, \(appState.username)")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                .padding(.top, BFDesignSystem.Layout.Spacing.large)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimated)
            
            // Stat Cards
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                StatCard(
                    title: "Streak",
                    value: "\(appState.streak) days",
                    icon: "flame.fill",
                    gradient: BFDesignSystem.Colors.warmGradient
                )
                .offset(x: isAnimated ? 0 : -50)
                
                StatCard(
                    title: "Savings",
                    value: "$\(String(format: "%.2f", appState.totalSavings))",
                    icon: "dollarsign.circle.fill",
                    gradient: BFDesignSystem.Colors.mindfulGradient
                )
                .offset(x: isAnimated ? 0 : 50)
            }
            .opacity(isAnimated ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isAnimated)
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                    .foregroundStyle(gradient)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3), value: isHovered)
                
                Text(title)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Text(value)
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundStyle(gradient)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(BFDesignSystem.Layout.Spacing.large)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withViewShadow(isHovered ? BFDesignSystem.Layout.Shadow.large : BFDesignSystem.Layout.Shadow.card)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

public struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var isRefreshing = false
    @State private var showingTransactionSheet = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var transactions: [BetFreeModels.Transaction] = []
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                BFDesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                        DashboardHeaderView(appState: appState)
                            .padding(.bottom, BFDesignSystem.Layout.Spacing.medium)
                        
                        TransactionListView(transactions: transactions)
                    }
                    .refreshable {
                        await refresh()
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    addButton
                }
                #endif
            }
            .sheet(isPresented: $showingTransactionSheet) {
                AddTransactionView()
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                loadTransactions()
            }
        }
    }
    
    private var addButton: some View {
        Button {
            HapticFeedback.fireAndForget()
            showingTransactionSheet = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
        }
    }
    
    private func refresh() async {
        isRefreshing = true
        HapticFeedback.fireAndForget()
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            loadTransactions()
            HapticFeedback.fireAndForget()
        } catch {
            errorMessage = error.localizedDescription
            showingErrorAlert = true
            HapticFeedback.fireAndForget()
        }
        
        isRefreshing = false
    }
    
    private func loadTransactions() {
        let manager = DataManagerFactory.createDataManager()
        transactions = manager.getAllTransactions()
    }
}

struct TransactionListView: View {
    let transactions: [BetFreeModels.Transaction]
    @State private var selectedTransaction: BetFreeModels.Transaction?
    @State private var isAnimated = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Section Header
            HStack {
                Text("Recent Transactions")
                    .font(BFDesignSystem.Typography.titleSmall)
                    .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                
                Spacer()
                
                NavigationLink {
                    Text("All Transactions")
                } label: {
                    Text("See All")
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
                }
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 20)
            .animation(.spring(response: 0.6).delay(0.3), value: isAnimated)
            
            if transactions.isEmpty {
                EmptyTransactionView()
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.4), value: isAnimated)
            } else {
                LazyVStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                    ForEach(Array(transactions.enumerated()), id: \.element.id) { index, transaction in
                        TransactionRow(transaction: transaction)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(y: isAnimated ? 0 : 20)
                            .animation(.spring(response: 0.6).delay(Double(index) * 0.1 + 0.4), value: isAnimated)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTransaction = transaction
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

struct EmptyTransactionView: View {
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            Image(systemName: "list.bullet.rectangle.portrait")
                .font(.system(size: 48))
                .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
            
            Text("No Transactions Today")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text("Add your first transaction using the + button")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(BFDesignSystem.Layout.Spacing.xxLarge)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withViewShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

struct TransactionRow: View {
    let transaction: BetFreeModels.Transaction
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Circle()
                .fill(transaction.amount > 0 ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.error)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: transaction.amount > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.rawValue)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                if let note = transaction.note {
                    Text(note)
                        .font(BFDesignSystem.Typography.bodySmall)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Text(formatAmount(transaction.amount))
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(transaction.amount > 0 ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.error)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withViewShadow(isHovered ? BFDesignSystem.Layout.Shadow.large : BFDesignSystem.Layout.Shadow.card)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "$\(abs(amount))"
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AppState.preview)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState.preview)
} 