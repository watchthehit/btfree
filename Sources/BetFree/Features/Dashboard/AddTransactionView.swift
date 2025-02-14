import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public final class AddTransactionViewModel: ObservableObject {
    @Published var amount = ""
    @Published var note = ""
    @Published var category = "Expense"
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var isAnimated = false
    
    let categories = ["Expense", "Savings"]
    
    @MainActor
    func saveTransaction() async throws {
        guard let amountValue = Double(amount) else {
            errorMessage = "Please enter a valid amount"
            showingError = true
            return
        }
        
        try CoreDataManager.shared.addTransaction(
            amount: category == "Expense" ? -amountValue : amountValue,
            note: note.isEmpty ? nil : note
        )
        HapticFeedback.fireAndForget(style: .medium)
    }
}

public struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddTransactionViewModel()
    @EnvironmentObject var appState: AppState
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            mainContent
        }
    }
    
    private var mainContent: some View {
        ZStack {
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                amountInputSection
                noteInputSection
                categorySelectionSection
                Spacer()
                saveButton
            }
            .padding()
        }
        .navigationTitle("Add Transaction")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                viewModel.isAnimated = true
            }
        }
    }
    
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            Text("Amount")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
            
            HStack {
                Text("$")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                
                TextField("0.00", text: $viewModel.amount)
                    .font(BFDesignSystem.Typography.titleLarge)
                    #if os(iOS)
                    .keyboardType(.decimalPad)
                    #endif
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.plain)
            }
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .opacity(viewModel.isAnimated ? 1 : 0)
            .offset(y: viewModel.isAnimated ? 0 : 20)
        }
    }
    
    private var noteInputSection: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            Text("Note")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
            
            TextField("What's this for?", text: $viewModel.note)
                .font(BFDesignSystem.Typography.bodyLarge)
                .padding()
                .background(BFDesignSystem.Colors.cardBackground)
                .cornerRadius(BFDesignSystem.Layout.CornerRadius.large)
                .withShadow(BFDesignSystem.Layout.Shadow.small)
        }
        .opacity(viewModel.isAnimated ? 1 : 0)
        .offset(y: viewModel.isAnimated ? 0 : 20)
    }
    
    private var categorySelectionSection: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            Text("Category")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
            
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                ForEach(viewModel.categories, id: \.self) { cat in
                    CategoryButton(
                        title: cat,
                        isSelected: viewModel.category == cat,
                        icon: cat == "Expense" ? "arrow.down.circle.fill" : "arrow.up.circle.fill",
                        color: cat == "Expense" ? BFDesignSystem.Colors.error : BFDesignSystem.Colors.success
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.category = cat
                            HapticFeedback.fireAndForget(style: .light)
                        }
                    }
                }
            }
        }
        .opacity(viewModel.isAnimated ? 1 : 0)
        .offset(y: viewModel.isAnimated ? 0 : 20)
    }
    
    private var saveButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.saveTransaction()
                    dismiss()
                } catch {
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.showingError = true
                    HapticFeedback.fireAndForget(style: .rigid)
                }
            }
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Transaction")
            }
            .font(BFDesignSystem.Typography.button)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
            .background(
                viewModel.amount.isEmpty ? 
                AnyShapeStyle(BFDesignSystem.Colors.textSecondary) :
                AnyShapeStyle(BFDesignSystem.Colors.primaryGradient)
            )
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
            .withShadow(BFDesignSystem.Layout.Shadow.button)
        }
        .disabled(viewModel.amount.isEmpty)
        .opacity(viewModel.isAnimated ? 1 : 0)
        .offset(y: viewModel.isAnimated ? 0 : 20)
    }
}

private struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                    .foregroundColor(isSelected ? .white : color)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                
                Text(title)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.large)
                    .fill(isSelected ? color : BFDesignSystem.Colors.cardBackground)
            )
            .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(AppState.preview())
} 