import SwiftUI
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct AddSavingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AddSavingViewModel()
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    Picker("Sport", selection: $viewModel.selectedSport) {
                        ForEach(Sport.allCases) { sport in
                            Text(sport.rawValue).tag(sport)
                        }
                    }
                    
                    TextField("Amount", text: $viewModel.amount)
                    #if os(iOS)
                        .keyboardType(.decimalPad)
                    #endif
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Notes (optional)", text: $viewModel.notes)
                }
                
                Section {
                    Button("Save") {
                        viewModel.save()
                    }
                    .disabled(viewModel.isSaving)
                }
            }
            .navigationTitle("Add Saving")
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
            .disabled(viewModel.isSaving)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.error ?? "An unknown error occurred")
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your saving has been recorded!")
            }
        }
    }
}

@MainActor
final class AddSavingViewModel: ObservableObject {
    @Published var selectedSport: Sport = .football
    @Published var amount = ""
    @Published var date = Date()
    @Published var notes = ""
    @Published var isSaving = false
    @Published var showSuccess = false
    @Published var showError = false
    @Published var error: String?
    
    var canSave: Bool {
        !amount.isEmpty && Double(amount) != nil
    }
    
    func save() {
        guard let amount = Double(amount) else { return }
        
        isSaving = true
        
        // TODO: Save to persistent storage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isSaving = false
            if Int.random(in: 0...10) > 8 {
                self.error = "Failed to save. Please try again."
                self.showError = true
            } else {
                self.showSuccess = true
            }
        }
    }
}

#Preview {
    AddSavingView()
        .environmentObject(AppState.preview)
}
