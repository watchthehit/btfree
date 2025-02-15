import SwiftUI

public struct AddSavingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    
    @State private var amount = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var selectedSport: Sport?
    @State private var showQuickAmounts = true
    
    private let quickAmounts = [10, 20, 50, 100, 200, 500]
    private let sports = [
        Sport(name: "Football", icon: "football.fill"),
        Sport(name: "Basketball", icon: "basketball.fill"),
        Sport(name: "Baseball", icon: "baseball.fill"),
        Sport(name: "Hockey", icon: "hockey.puck.fill"),
        Sport(name: "Soccer", icon: "soccerball"),
        Sport(name: "Tennis", icon: "tennis.racket"),
        Sport(name: "Golf", icon: "golf.ball.fill"),
        Sport(name: "Racing", icon: "car.fill")
    ]
    
    public var body: some View {
        NavigationView {
            Form {
                // Quick Add Section
                if showQuickAmounts {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(quickAmounts, id: \.self) { value in
                                    QuickAmountButton(amount: value) {
                                        amount = String(value)
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 8)
                    } header: {
                        Text("Quick Add")
                    }
                }
                
                // Amount Section
                Section {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Avoided Bet Amount")
                }
                
                // Sport Section
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sports, id: \.name) { sport in
                                SportButton(
                                    sport: sport,
                                    isSelected: selectedSport?.name == sport.name
                                ) {
                                    selectedSport = sport
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 8)
                } header: {
                    Text("Sport")
                }
                
                // Description Section
                Section {
                    TextField("Description (optional)", text: $description)
                } header: {
                    Text("Description")
                }
                
                // Date Section
                Section {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
            }
            .navigationTitle("Add Saving")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSaving()
                        dismiss()
                    }
                    .disabled(amount.isEmpty || selectedSport == nil)
                }
            }
        }
    }
    
    private func saveSaving() {
        guard let amountValue = Double(amount),
              let sport = selectedSport else {
            return
        }
        
        let saving = Saving(
            amount: amountValue,
            description: description.isEmpty ? "Avoided bet on \(sport.name)" : description,
            date: date,
            sport: sport.name
        )
        
        appState.addSaving(saving)
    }
}

private struct Sport {
    let name: String
    let icon: String
}

private struct QuickAmountButton: View {
    let amount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("$\(amount)")
                .font(BFDesignSystem.Typography.labelLarge)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(BFDesignSystem.Colors.primary.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

private struct SportButton: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: sport.icon)
                    .font(.title3)
                Text(sport.name)
                    .font(BFDesignSystem.Typography.labelSmall)
            }
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary)
            .frame(width: 80)
            .padding(.vertical, 8)
            .background(isSelected ? BFDesignSystem.Colors.primary.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
    }
}

#Preview {
    AddSavingView()
        .environmentObject(AppState.preview)
}
