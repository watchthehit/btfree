import SwiftUI

public struct SavingsView: View {
    @StateObject private var manager = SavingsManager()
    @State private var newAmount: String = ""
    @State private var showingAddSheet = false
    @State private var showingCelebration = false
    @State private var celebrationMessage = ""
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            // Total Savings Card
            savingsCard
            
            // Stats Grid
            statsGrid
            
            // Add Savings Button
            addButton
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: .savingsMilestoneReached)) { notification in
            if let milestone = notification.userInfo?["milestone"] as? Int {
                celebrationMessage = "Congratulations! You've saved \(manager.formatAmount(Double(milestone)))!"
                showingCelebration = true
                BFHaptics.achievement()
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            addSavingsSheet
        }
        .alert("Milestone Reached! 🎉", isPresented: $showingCelebration) {
            Button("Thanks!", role: .cancel) {}
        } message: {
            Text(celebrationMessage)
        }
    }
    
    private var savingsCard: some View {
        BFCard(style: .elevated) {
            VStack(alignment: .center, spacing: 12) {
                Text("Total Saved")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(manager.formatAmount(manager.totalSaved))
                    .font(BFDesignSystem.Typography.displayLarge)
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .semanticMeaning("Total Savings Card")
        .semanticValue("\(manager.formatAmount(manager.totalSaved)) saved in total")
        .semanticHint("Shows your total savings from not gambling")
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            statCard(
                title: "Daily Average",
                value: manager.formatAmount(manager.dailyAverage),
                icon: "chart.line.uptrend.xyaxis",
                color: BFDesignSystem.Colors.primary
            )
            
            statCard(
                title: "Streak",
                value: "\(manager.streakDays) days",
                icon: "flame.fill",
                color: BFDesignSystem.Colors.warning
            )
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        BFCard(style: .default) {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(BFDesignSystem.Typography.labelMedium)
                }
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(color)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .semanticMeaning("\(title) Card")
        .semanticValue(value)
        .semanticHint("Shows your \(title.lowercased())")
    }
    
    private var addButton: some View {
        Button {
            showingAddSheet = true
            BFHaptics.light()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Savings")
            }
            .font(BFDesignSystem.Typography.labelLarge)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(BFDesignSystem.Colors.primary)
            .cornerRadius(12)
        }
        .semanticMeaning("Add Savings Button")
        .semanticHint("Double tap to add new savings amount")
    }
    
    private var addSavingsSheet: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $newAmount)
                        .keyboardType(.decimalPad)
                        .semanticMeaning("Savings Amount Input")
                        .semanticHint("Enter the amount you saved")
                }
                
                Section {
                    Button("Add Savings") {
                        if let amount = Double(newAmount) {
                            manager.addSaving(amount)
                            BFHaptics.success()
                            showingAddSheet = false
                            newAmount = ""
                        }
                    }
                    .disabled(Double(newAmount) == nil)
                }
            }
            .navigationTitle("Add Savings")
            .navigationBarItems(trailing: Button("Cancel") {
                showingAddSheet = false
                BFHaptics.light()
            })
        }
    }
}

#Preview {
    SavingsView()
}
