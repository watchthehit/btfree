import SwiftUI

struct ProgressChartView: View {
    @ObservedObject var appState: AppState
    let timeframe: ProgressView.Timeframe
    @State private var isHovered: Int? = nil
    
    private var data: [(date: Date, amount: Double)] {
        // TODO: Replace with actual data from Core Data
        let calendar = Calendar.current
        let today = Date()
        
        switch timeframe {
        case .week:
            return (0..<7).map { day in
                let date = calendar.date(byAdding: .day, value: -day, to: today)!
                return (date, Double.random(in: 0...100)) // Replace with actual data
            }.reversed()
        case .month:
            return (0..<30).map { day in
                let date = calendar.date(byAdding: .day, value: -day, to: today)!
                return (date, Double.random(in: 0...100)) // Replace with actual data
            }.reversed()
        case .year:
            return (0..<12).map { month in
                let date = calendar.date(byAdding: .month, value: -month, to: today)!
                return (date, Double.random(in: 0...1200)) // Replace with actual data
            }.reversed()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        switch timeframe {
        case .week:
            formatter.dateFormat = "EEE"
        case .month:
            formatter.dateFormat = "d MMM"
        case .year:
            formatter.dateFormat = "MMM"
        }
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Chart Title
            Text("Savings Over Time")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
            
            // Chart
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    // Background Grid
                    VStack(spacing: 0) {
                        ForEach(0..<4) { i in
                            Divider()
                                .background(BFDesignSystem.Colors.separator)
                                .frame(height: 1)
                            if i < 3 {
                                Spacer()
                            }
                        }
                    }
                    
                    // Chart Lines
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height - 30 // Reserve space for labels
                        let step = width / CGFloat(data.count - 1)
                        
                        let points = data.enumerated().map { index, item in
                            CGPoint(
                                x: CGFloat(index) * step,
                                y: height * (1 - CGFloat(item.amount / data.map(\.amount).max()!))
                            )
                        }
                        
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(BFDesignSystem.Colors.primary, lineWidth: 2)
                    
                    // Data Points
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        let width = geometry.size.width
                        let height = geometry.size.height - 30
                        let step = width / CGFloat(data.count - 1)
                        let x = CGFloat(index) * step
                        let y = height * (1 - CGFloat(item.amount / data.map(\.amount).max()!))
                        
                        Circle()
                            .fill(BFDesignSystem.Colors.primary)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                            .overlay(
                                Circle()
                                    .stroke(BFDesignSystem.Colors.cardBackground, lineWidth: 2)
                                    .frame(width: 8, height: 8)
                            )
                            .overlay(
                                Text("$\(Int(item.amount))")
                                    .font(BFDesignSystem.Typography.caption)
                                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                                    .opacity(isHovered == index ? 1 : 0)
                                    .offset(y: -20)
                            )
                            .onHover { hovering in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isHovered = hovering ? index : nil
                                }
                            }
                        
                        // X-Axis Labels
                        Text(dateFormatter.string(from: item.date))
                            .font(BFDesignSystem.Typography.caption)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .position(x: x, y: height + 15)
                    }
                }
            }
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withShadow(BFDesignSystem.Layout.Shadow.card)
    }
}

#Preview {
    VStack {
        ForEach(ProgressView.Timeframe.allCases, id: \.self) { timeframe in
            ProgressChartView(appState: AppState(), timeframe: timeframe)
                .frame(height: 200)
                .padding()
        }
    }
    .background(BFDesignSystem.Colors.background)
} 