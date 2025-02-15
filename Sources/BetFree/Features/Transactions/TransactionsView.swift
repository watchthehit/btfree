import SwiftUI

public struct TransactionsView: View {
    @State private var transactions: [Transaction] = []
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List(transactions, id: \.id) { txn in
                VStack(alignment: .leading) {
                    Text(String(format: "Amount: %.2f", txn.amount))
                        .font(.headline)
                    Text("Category: \(txn.category)")
                        .font(.subheadline)
                    Text("Date: \(txn.date, formatter: dateFormatter)")
                        .font(.caption)
                    if let note = txn.note, !note.isEmpty {
                        Text("Note: \(note)")
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .navigationTitle("Transactions")
            .onAppear(perform: loadTransactions)
            .refreshable {
                loadTransactions()
            }
        }
    }
    
    private func loadTransactions() {
        let manager = CoreDataManager.shared
        transactions = manager.getTodaysTransactions()
    }
}

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}() 