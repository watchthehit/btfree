import SwiftUI
import BetFreeModels
import BetFreeUI

@MainActor
final class CravingViewModel: ObservableObject {
    @Published private(set) var selectedIntensity: Int = 1
    @Published private(set) var selectedTriggers: Set<Trigger> = []
    @Published private(set) var selectedStrategies: Set<CopingStrategy> = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published var showError = false
    @Published var showSuccess = false
    
    private let dataManager: BetFreeDataManager
    private let cravingManager: CravingManager
    
    init(dataManager: BetFreeDataManager? = nil,
         cravingManager: CravingManager? = nil) {
        self.dataManager = dataManager ?? DataManagerFactory.createDataManager()
        self.cravingManager = cravingManager ?? CravingManager()
    }
    
    func setIntensity(_ value: Int) {
        selectedIntensity = max(1, min(5, value))
    }
    
    func toggleTrigger(_ trigger: Trigger) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
    }
    
    func toggleStrategy(_ strategy: CopingStrategy) {
        if selectedStrategies.contains(strategy) {
            selectedStrategies.remove(strategy)
        } else {
            selectedStrategies.insert(strategy)
        }
    }
    
    func logCraving() async {
        guard validate() else { return }
        
        isLoading = true
        
        do {
            // Create craving data
            let triggersString = selectedTriggers.map { $0.rawValue }.joined(separator: ",")
            let strategiesString = selectedStrategies.map { $0.rawValue }.joined(separator: ",")
            
            // Create craving record
            let craving = try await dataManager.createCraving(
                intensity: selectedIntensity,
                triggers: triggersString,
                strategies: strategiesString,
                timestamp: Date(),
                duration: 0  // Default duration
            )
            
            // Update craving manager
            cravingManager.add(craving)
            
            // Trigger appropriate haptic feedback
            if selectedIntensity >= 4 {
                BFHaptics.warning()
            } else {
                BFHaptics.success()
            }
            
            // Show success
            showSuccess = true
        } catch {
            self.error = error.localizedDescription
            showError = true
            BFHaptics.error()
        }
        
        isLoading = false
    }
    
    private func validate() -> Bool {
        // Validate intensity
        guard selectedIntensity >= 1 && selectedIntensity <= 5 else {
            error = "Please select an intensity level"
            showError = true
            return false
        }
        
        // Validate triggers
        guard !selectedTriggers.isEmpty else {
            error = "Please select at least one trigger"
            showError = true
            return false
        }
        
        // Validate strategies
        guard !selectedStrategies.isEmpty else {
            error = "Please select at least one coping strategy"
            showError = true
            return false
        }
        
        return true
    }
} 