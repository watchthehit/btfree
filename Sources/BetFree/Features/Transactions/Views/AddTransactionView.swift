import SwiftUI
import CoreData
import BetFreeUI

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
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                // Amount Section
                Section {
                    VStack(alignment: .leading) {
                        Text("Amount")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        TextField("Amount", text: $amount)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    }
                } header: {
                    Text("Transaction Details")
                }
                
                // Category Section
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(TransactionCategory.allCases) { category in
                            Label(category.name, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                // Note Section
                Section {
                    VStack(alignment: .leading) {
                        Text("Note")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        TextField("Optional note", text: $note)
                    }
                    
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
                
                Section {
                    Button {
                        saveTransaction()
                    } label: {
                        Text("Save Transaction")
                            .font(BFDesignSystem.Typography.bodyLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(BFDesignSystem.Colors.primary)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Add Transaction")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #endif
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount.trimmingCharacters(in: .whitespaces)) else {
            alertMessage = "Please enter a valid amount"
            showingAlert = true
            return
        }
        
        guard amountValue > 0 else {
            alertMessage = "Amount must be greater than zero"
            showingAlert = true
            return
        }
        
        do {
            try appState.addTransaction(amount: amountValue, note: note.isEmpty ? nil : note)
            dismiss()
        } catch {
            alertMessage = "Failed to save transaction: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AddTransactionView()
            .environmentObject(AppState.preview)
    }
}
