import SwiftUI
import CoreData
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var amount = ""
    @State private var note = ""
    @State private var date = Date()
    @State private var category: TransactionCategory = .other
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                if isLoading {
                    Section {
                        HStack {
                            Spacer()
                            SwiftUI.ProgressView()
                                .progressViewStyle(.circular)
                            Spacer()
                        }
                    }
                }
                
                // Amount Section
                Section {
                    VStack(alignment: .leading) {
                        Text("Amount")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        TextField("Amount", text: $amount)
                    }
                } header: {
                    Text("Transaction Details")
                }
                
                // Category Section
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(TransactionCategory.allCases) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                // Note Section
                Section {
                    VStack(alignment: .leading) {
                        Text("Note (Optional)")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        TextField("Add a note", text: $note)
                    }
                } header: {
                    Text("Additional Details")
                }
                
                // Date Section
                Section {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            do {
                                try await saveTransaction()
                            } catch {
                                alertMessage = "Failed to save transaction: \(error.localizedDescription)"
                                showingAlert = true
                            }
                        }
                    }
                    .disabled(amount.isEmpty || isLoading)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    @MainActor
    private func saveTransaction() async throws {
        guard let amountValue = Double(amount) else {
            alertMessage = "Please enter a valid amount"
            showingAlert = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let transaction = Transaction(
            amount: amountValue,
            category: category,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        // Save transaction
        let manager = MockCDManager.shared
        try manager.addTransaction(transaction)
        
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AddTransactionView()
            .environmentObject(AppState.preview)
    }
}
