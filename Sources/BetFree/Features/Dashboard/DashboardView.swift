import SwiftUI
import ComposableArchitecture
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
                    value: "$\(String(format: "%.2f", appState.savings))",
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
        .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.large : BFDesignSystem.Layout.Shadow.card)
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
                AddTransactionView()
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
            
            let transactions = CoreDataManager.shared.getTodaysTransactions()
            
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
                .font(BFDesignSystem.Typography.body)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(BFDesignSystem.Layout.Spacing.xxLarge)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withShadow(BFDesignSystem.Layout.Shadow.card)
        .padding(.horizontal)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    @State private var isHovered = false
    
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
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3), value: isHovered)
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
        .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.card)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState.preview())
} 