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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Details Section
                    BFCard(style: .elevated) {
                        VStack(spacing: 16) {
                            Picker("Sport", selection: $viewModel.selectedSport) {
                                ForEach(Sport.allCases) { sport in
                                    Text(sport.rawValue).tag(sport)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Amount")
                                    .font(BFDesignSystem.Typography.labelMedium)
                                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                                TextField("Amount", text: $viewModel.amount)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    #if os(iOS)
                                    .keyboardType(.decimalPad)
                                    #endif
                            }
                            
                            DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                        }
                        .padding()
                    }
                    
                    // Additional Information Section
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (optional)")
                                .font(BFDesignSystem.Typography.labelMedium)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            TextField("Add notes", text: $viewModel.notes)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                    }
                    
                    // Save Button
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.save()
                            } catch {
                                viewModel.showError = true
                                viewModel.error = error.localizedDescription
                            }
                        }
                    }) {
                        HStack {
                            if viewModel.isSaving {
                                SwiftUI.ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Save")
                                    .font(BFDesignSystem.Typography.labelLarge)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BFDesignSystem.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isSaving || !viewModel.canSave)
                }
                .padding()
            }
            .navigationTitle("Add Saving")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
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
    
    func save() async throws {
        guard let amount = Double(amount) else { return }
        
        isSaving = true
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Save the amount
        try await addSaving(amount: amount, note: notes)
    }
    
    func addSaving(amount: Double, note: String) async throws {
        isSaving = true
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Implement actual saving logic
        print("Adding saving: $\(amount) with note: \(note)")
        
        isSaving = false
        showSuccess = true
    }
}

#Preview {
    AddSavingView()
        .environmentObject(AppState.preview)
}
