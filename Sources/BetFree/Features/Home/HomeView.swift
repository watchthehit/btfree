import SwiftUI
import CoreData

public struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: UserProfileEntity.entity(),
        sortDescriptors: []
    ) private var users: FetchedResults<UserProfileEntity>
    
    @State private var showingAddTransaction = false
    @State private var showingHelp = false
    
    private var user: UserProfileEntity? {
        users.first
    }
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome\(user?.name.isEmpty == false ? ", \(user?.name ?? "")" : "")")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Let's make today count!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Stats Section
                    HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        BFStatCard(
                            value: "\(user?.streak ?? 0)",
                            label: "Day Streak",
                            icon: "flame.fill",
                            gradient: .orangeGradient
                        )
                        
                        BFStatCard(
                            value: "$\(Int(user?.totalSavings ?? 0))",
                            label: "Total Saved",
                            icon: "dollarsign.circle.fill",
                            gradient: .greenGradient
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            ActionCard(
                                title: "Add Transaction",
                                icon: "plus.circle.fill",
                                color: .blue
                            ) {
                                showingAddTransaction = true
                            }
                            
                            ActionCard(
                                title: "Get Help",
                                icon: "questionmark.circle.fill",
                                color: .purple
                            ) {
                                showingHelp = true
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Daily Limit Section
                    if let dailyLimit = user?.dailyLimit, dailyLimit > 0 {
                        BFStatCard(
                            value: "$\(Int(dailyLimit))",
                            label: "Daily Limit",
                            icon: "chart.line.downtrend.xyaxis",
                            gradient: .blueGradient
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddTransaction) {
                // TODO: Add transaction view
                Text("Add Transaction")
            }
            .sheet(isPresented: $showingHelp) {
                // TODO: Help view
                Text("Help & Resources")
            }
        }
    }
}