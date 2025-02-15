import SwiftUI
import CoreData
import BetFree

public struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var category: TransactionCategory = .other
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                // Amount Section
                Section {
                    HStack {
                        Text("$")
                            .foregroundColor(.secondary)
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("Amount")
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
                    TextField("Optional note", text: $note)
                } header: {
                    Text("Note")
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                }
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
