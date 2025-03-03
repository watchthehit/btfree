import SwiftUI
import Foundation

struct CravingReportView: View {
    @EnvironmentObject private var appState: AppState
    @State private var intensity: Double = 5
    @State private var selectedTrigger: String = ""
    @State private var notes: String = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Craving Intensity")) {
                    VStack {
                        Slider(value: $intensity, in: 1...10, step: 1)
                        
                        HStack {
                            Text("1")
                            Spacer()
                            Text(String(format: "%.0f", intensity))
                                .font(.headline)
                            Spacer()
                            Text("10")
                        }
                    }
                }
                
                Section(header: Text("What triggered this craving?")) {
                    Picker("Select a trigger", selection: $selectedTrigger) {
                        Text("Select").tag("")
                        
                        ForEach(appState.userTriggers, id: \.self) { trigger in
                            Text(trigger).tag(trigger)
                        }
                    }
                    
                    if appState.userTriggers.isEmpty {
                        Text("No triggers defined yet. Add them in Settings.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Button("Submit Report") {
                    submitReport()
                }
                .disabled(intensity == 0 || (selectedTrigger.isEmpty && !appState.userTriggers.isEmpty))
            }
            .navigationTitle("Craving Report")
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Report Submitted"),
                    message: Text("Your craving report has been recorded."),
                    dismissButton: .default(Text("OK")) {
                        resetForm()
                    }
                )
            }
        }
    }
    
    private func submitReport() {
        // Here you would normally save the report to your data store
        // For now, we'll just show a confirmation
        showingConfirmation = true
    }
    
    private func resetForm() {
        intensity = 5
        selectedTrigger = ""
        notes = ""
    }
}

struct CravingReportView_Previews: PreviewProvider {
    static var previews: some View {
        CravingReportView()
            .environmentObject(AppState())
    }
} 