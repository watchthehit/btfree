import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct AddTransactionView: View {
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount = ""
    @State private var note = ""
    @State private var category = "Expense"
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let categories = ["Expense", "Savings"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    #if os(iOS)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    #else
                    TextField("Amount", text: $amount)
                    #endif
                    
                    TextField("Note (Optional)", text: $note)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                
                Section {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(amount.isEmpty)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else {
            errorMessage = "Please enter a valid amount"
            showingError = true
            return
        }
        
        do {
            try CoreDataManager.shared.addTransaction(
                amount: category == "Expense" ? -amountValue : amountValue,
                note: note
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
} 