import SwiftUI
import CoreData

public struct ProgressChartView: View {
    @ObservedObject var appState: AppState
    let timeframe: ProgressView.Timeframe
    @State private var isHovered: Bool = false
    @State private var hoveredValue: (date: Date, value: Double)?
    
    private var data: [(date: Date, value: Double)] {
        let calendar = Calendar.current
        let now = Date()
        
        let numberOfPoints: Int
        let component: Calendar.Component
        
        switch timeframe {
        case .week:
            numberOfPoints = 7
            component = .day
        case .month:
            numberOfPoints = 30
            component = .day
        case .year:
            numberOfPoints = 12
            component = .month
        }
        
        return fetchTransactionData(for: numberOfPoints, component: component, from: now, using: calendar)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                // Chart Title with Value
                if let hoveredValue = hoveredValue {
                    Text("$\(String(format: "%.2f", hoveredValue.value))")
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                } else {
                    Text("Savings Over Time")
                        .font(BFDesignSystem.Typography.titleSmall)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                }
                
                // Chart
                ZStack {
                    // Background Grid
                    Path { path in
                        for i in 0...4 {
                            let y = geometry.size.height * CGFloat(i) / 4
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                    }
                    .stroke(BFDesignSystem.Colors.separator, lineWidth: 1)
                    
                    // Line Chart
                    if !data.isEmpty {
                        Path { path in
                            let points = data.enumerated().map { index, item -> CGPoint in
                                let x = geometry.size.width * CGFloat(index) / CGFloat(data.count - 1)
                                let y = geometry.size.height * (1 - CGFloat(item.value / (maxValue() ?? 1)))
                                return CGPoint(x: x, y: y)
                            }
                            
                            path.move(to: points[0])
                            for point in points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(BFDesignSystem.Colors.primary, lineWidth: 2)
                        
                        // Data Points
                        ForEach(data.indices, id: \.self) { index in
                            let point = data[index]
                            let x = geometry.size.width * CGFloat(index) / CGFloat(data.count - 1)
                            let y = geometry.size.height * (1 - CGFloat(point.value / (maxValue() ?? 1)))
                            
                            Circle()
                                .fill(BFDesignSystem.Colors.primary)
                                .frame(width: 8, height: 8)
                                .position(x: x, y: y)
                                .onHover { hovering in
                                    if hovering {
                                        hoveredValue = point
                                    } else if hoveredValue?.date == point.date {
                                        hoveredValue = nil
                                    }
                                }
                        }
                    }
                }
                
                // X-Axis Labels
                HStack {
                    ForEach(data.indices, id: \.self) { index in
                        Text(formatDate(data[index].date))
                            .font(BFDesignSystem.Typography.caption)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .rotationEffect(.degrees(-45))
                    }
                }
                .padding(.top, BFDesignSystem.Layout.Spacing.medium)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        switch timeframe {
        case .week:
            dateFormatter.dateFormat = "EEE"
        case .month:
            dateFormatter.dateFormat = "d MMM"
        case .year:
            dateFormatter.dateFormat = "MMM"
        }
        return dateFormatter.string(from: date)
    }
    
    private func maxValue() -> Double? {
        data.map { $0.value }.max()
    }
    
    private func fetchTransactionData(
        for count: Int,
        component: Calendar.Component,
        from date: Date,
        using calendar: Calendar
    ) -> [(date: Date, value: Double)] {
        var result: [(date: Date, value: Double)] = []
        
        // Create date components for the range
        let endDate = calendar.startOfDay(for: date)
        guard let startDate = calendar.date(byAdding: component, value: -(count - 1), to: endDate) else {
            return []
        }
        
        // Fetch transactions for the date range
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)]
        
        let transactions: [Transaction]
        do {
            transactions = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
        
        // Group transactions by date
        var datePoints: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            datePoints.append(currentDate)
            currentDate = calendar.date(byAdding: component, value: 1, to: currentDate) ?? currentDate
        }
        
        // Calculate cumulative savings for each date
        var runningTotal: Double = 0
        for date in datePoints {
            let dateTransactions = transactions.filter { calendar.isDate($0.date, equalTo: date, toGranularity: component) }
            let dailySavings = dateTransactions.reduce(0.0) { $0 + $1.amount }
            runningTotal += dailySavings
            result.append((date: date, value: runningTotal))
        }
        
        return result
    }
}

#Preview {
    PreviewAppState { appState in
        ProgressChartView(appState: appState, timeframe: .week)
            .frame(height: 200)
            .padding()
    }
    .background(BFDesignSystem.Colors.background)
} 