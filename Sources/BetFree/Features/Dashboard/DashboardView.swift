import SwiftUI
import ComposableArchitecture
#if canImport(UIKit)
import UIKit
#endif

struct DashboardHeaderView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Welcome back, \(appState.username)")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                .padding(.top, BFDesignSystem.Layout.Spacing.large)
            
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                StatCard(
                    title: "Streak",
                    value: "\(appState.streak) days",
                    icon: "flame.fill",
                    gradient: BFDesignSystem.Colors.warmGradient
                )
                
                StatCard(
                    title: "Savings",
                    value: "$\(String(format: "%.2f", appState.savings))",
                    icon: "dollarsign.circle.fill",
                    gradient: BFDesignSystem.Colors.mindfulGradient
                )
            }
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                    .foregroundStyle(gradient)
                
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
        .withShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

public struct DashboardView: View {
    @ObservedObject var appState: AppState
    @State private var isRefreshing = false
    @State private var showingTransactionSheet = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    public var body: some View {
        NavigationView {
            ZStack {
                BFDesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                        DashboardHeaderView(appState: appState)
                            .padding(.bottom, BFDesignSystem.Layout.Spacing.medium)
                        
                        TransactionListView(appState: appState)
                    }
                    .refreshable {
                        await refresh()
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    addButton
                }
            }
            .sheet(isPresented: $showingTransactionSheet) {
                AddTransactionView(appState: appState)
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
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
            HapticFeedback.fireAndForget()
        } catch {
            errorMessage = error.localizedDescription
            showingErrorAlert = true
            HapticFeedback.fireAndForget()
        }
        
        isRefreshing = false
    }
}

struct TransactionListView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTransaction: Transaction?
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
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
            
            LazyVStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                ForEach(CoreDataManager.shared.getTodaysTransactions(), id: \.id) { transaction in
                    TransactionRow(transaction: transaction)
                        .onTapGesture {
                            selectedTransaction = transaction
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Transaction Icon
            ZStack {
                Circle()
                    .fill(transaction.amount < 0 ? 
                          BFDesignSystem.Colors.error.opacity(0.1) :
                          BFDesignSystem.Colors.success.opacity(0.1))
                    .frame(width: BFDesignSystem.Layout.Size.iconXLarge, 
                           height: BFDesignSystem.Layout.Size.iconXLarge)
                
                Image(systemName: transaction.amount < 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                    .foregroundColor(transaction.amount < 0 ? 
                                   BFDesignSystem.Colors.error :
                                   BFDesignSystem.Colors.success)
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.xxSmall) {
                Text(transaction.note ?? "No note")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(transaction.category)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            // Amount
            Text("$\(String(format: "%.2f", abs(transaction.amount)))")
                .font(BFDesignSystem.Typography.bodyLargeMedium)
                .foregroundColor(transaction.amount < 0 ? 
                               BFDesignSystem.Colors.error :
                               BFDesignSystem.Colors.success)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

#Preview {
    DashboardView(appState: AppState())
} 