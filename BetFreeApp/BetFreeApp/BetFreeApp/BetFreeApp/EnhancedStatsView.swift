import SwiftUI
import Charts

struct EnhancedStatsView: View {
    @EnvironmentObject var appState: EnhancedAppState
    @StateObject private var viewModel: EnhancedStatsViewModel
    @State private var showingNewComponents = false // Hide by default to match the UI in the image
    
    // Create a date formatter as a function to avoid ViewBuilder issues
    private func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter
    }
    
    init() {
        // Initialize with a temporary appState, will be replaced by the @EnvironmentObject
        _viewModel = StateObject(wrappedValue: EnhancedStatsViewModel(appState: EnhancedAppState()))
    }
    
    var body: some View {
        ZStack {
            // Background color to match dark mode
            BFColorSystem.background
                .ignoresSafeArea()
            
            // Use the new standardized BFScrollView
            BFScrollView(
                showsIndicators: true,
                bottomSpacing: 100,
                heightMultiplier: 1.3
            ) {
                VStack(spacing: 20) {
                    // Period selector
                    periodSelector
                    
                    // Main content
                    if viewModel.isLoading {
                        SwiftUI.ProgressView()
                            .padding(.vertical, 50)
                            .frame(maxWidth: .infinity)
                    } else {
                        mainContent
                    }
                    
                    // Add space at the bottom to ensure scrollability
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            // Refresh view model with current app state
            viewModel.appState = appState
            
            // Load data when view appears
            viewModel.loadStatsData()
        }
    }
    
    // MARK: - Views
    
    private var periodSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Time Period")
                .font(.headline)
                .foregroundColor(BFColorSystem.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(StatsPeriod.allCases, id: \.self) { period in
                        Button(action: {
                            viewModel.changePeriod(to: period)
                        }) {
                            Text(period.rawValue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(viewModel.selectedPeriod == period ? BFColorSystem.primary : Color(hex: "#232B3D"))
                                )
                                .foregroundColor(viewModel.selectedPeriod == period ? .white : BFColorSystem.textPrimary)
                        }
                    }
                }
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 24) {
            // Header with date range
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.formatDateRange())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(BFColorSystem.textPrimary)
                
                Text("Urge Statistics Summary")
                    .font(.subheadline)
                    .foregroundColor(BFColorSystem.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Summary cards
            summarySection
            
            // Stats breakdown
            breakdownSection
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Summary")
                .font(.headline)
                .foregroundColor(BFColorSystem.textPrimary)
            
            HStack(spacing: 15) {
                // Total urges card
                summaryCard(
                    title: "Total",
                    value: "\(viewModel.getTotalUrges())",
                    icon: "flame.fill",
                    iconColor: BFColorSystem.primary
                )
                
                // Average urges card
                summaryCard(
                    title: "Daily Avg",
                    value: String(format: "%.1f", viewModel.getAverageUrges()),
                    icon: "chart.bar.fill",
                    iconColor: BFColorSystem.primary
                )
                
                // Streak days card
                summaryCard(
                    title: "Streak",
                    value: "\(viewModel.getStreakDays()) days",
                    icon: "calendar",
                    iconColor: BFColorSystem.primary
                )
            }
        }
    }
    
    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Urge Breakdown")
                .font(.headline)
                .foregroundColor(BFColorSystem.textPrimary)
                .padding(.top, 10)
            
            VStack(spacing: 8) {
                let formatter = createDateFormatter()
                
                ForEach(viewModel.statsData.sorted(by: { $0.date > $1.date }), id: \.date) { point in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(formatter.string(from: point.date))
                            .font(.subheadline)
                            .foregroundColor(BFColorSystem.textPrimary)
                        
                        HStack {
                            Text("\(point.count) urges tracked")
                                .foregroundColor(BFColorSystem.textSecondary)
                            
                            Spacer()
                            
                            ForEach(0..<min(5, point.count), id: \.self) { _ in
                                Image(systemName: "flame.fill")
                                    .foregroundColor(BFColorSystem.streak)
                                    .font(.caption)
                            }
                            
                            if point.count > 5 {
                                Text("+\(point.count - 5)")
                                    .font(.caption)
                                    .foregroundColor(BFColorSystem.textSecondary)
                            }
                        }
                        
                        Divider()
                            .background(BFColorSystem.divider)
                    }
                    .padding(.vertical, 15)
                }
                
                // Add placeholder rows if less than 7 days of data
                if viewModel.statsData.count < 7 {
                    ForEach(viewModel.statsData.count..<7, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("No data")
                                .font(.subheadline)
                                .foregroundColor(BFColorSystem.textSecondary)
                            
                            HStack {
                                Text("0 urges tracked")
                                    .foregroundColor(BFColorSystem.textSecondary)
                                
                                Spacer()
                            }
                            
                            Divider()
                                .background(BFColorSystem.divider)
                        }
                        .padding(.vertical, 15)
                    }
                }
                
                // Extra spacing at the bottom
                Spacer().frame(height: 100)
            }
            .padding(.vertical, 10)
        }
    }
    
    // MARK: - Helper Views
    
    private func summaryCard(title: String, value: String, icon: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.callout)
                    .foregroundColor(BFColorSystem.textSecondary)
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(BFColorSystem.textPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#232B3D"))
        .cornerRadius(12)
    }
}

// MARK: - Previews
struct EnhancedStatsView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedStatsView()
            .environmentObject(EnhancedAppState())
    }
}