import SwiftUI
import BetFreeUI
import BetFreeModels

public struct CravingReportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CravingReportViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                Section("Intensity") {
                    Slider(value: $viewModel.intensity, in: 1...10, step: 1) {
                        Text("Intensity: \(Int(viewModel.intensity))")
                    }
                }
                
                Section("What triggered this?") {
                    TextField("Describe the trigger", text: $viewModel.trigger, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Coping Strategy") {
                    TextField("What will you do instead?", text: $viewModel.strategy, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Report Craving")
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
                                try await viewModel.saveCraving()
                                dismiss()
                            } catch {
                                print("Error saving craving: \(error)")
                            }
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

@MainActor
final class CravingReportViewModel: ObservableObject {
    @Published var intensity: Double = 5
    @Published var trigger: String = ""
    @Published var strategy: String = ""
    
    private let dataManager: BetFreeDataManager
    
    var isValid: Bool {
        !trigger.isEmpty && !strategy.isEmpty
    }
    
    @MainActor
    init() {
        self.dataManager = CoreDataManager.shared
    }
    
    func saveCraving() async throws {
        _ = try await dataManager.createCraving(
            intensity: Int(intensity),
            triggers: trigger,
            strategies: strategy,
            timestamp: Date(),
            duration: 0
        )
    }
}

#Preview {
    CravingReportView()
} 