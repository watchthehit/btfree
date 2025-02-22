# BetFree Features Documentation

## Core Features

### Progress Tracking

#### Streak System
```swift
// Core Data model
@NSManaged public var streak: Int32
@NSManaged public var lastCheckIn: Date?
```
- Daily check-in system
- Streak maintenance
- Milestone celebrations
- Progress visualization
- Persistent storage with Core Data

#### Savings Calculator
```swift
// Core Data model
@NSManaged public var totalSavings: Double
@NSManaged public var dailyLimit: Double
```
- Daily limit tracking
- Savings visualization
- Goal progress
- Historical data
- Persistent storage

### Transaction Tracking

#### Transaction Model
```swift
// Core Data entity
@NSManaged public var id: UUID
@NSManaged public var amount: Double
@NSManaged public var date: Date
@NSManaged public var note: String?
@NSManaged public var category: String?
```

#### Features
- Add new transactions
- View transaction history
- Daily spending summary
- Category-based tracking
- Notes and metadata
- Persistent storage

### Achievement System

#### Types of Achievements
1. **Streak Based**
   - First Step (1 day)
   - Week Warrior (7 days)
   - Monthly Marvel (30 days)
   - Quarterly Victor (90 days)
   - Annual Legend (365 days)

2. **Savings Based**
   - Money Master ($100)
   - Savings Champion ($1,000)
   - Wealth Builder ($5,000)
   - Fortune Maker ($10,000)

3. **Engagement Based**
   - Early Bird (Morning check-ins)
   - Night Owl (Evening check-ins)
   - Consistency King (Regular check-ins)

## User Experience

### Onboarding Experience

#### 1. Welcome Screen
- Animated welcome message with smooth transitions
- Clear value proposition
- Success stories with real user testimonials
- Key statistics display
- Optimized layout with proper spacing
- Progress indicator showing onboarding steps

#### 2. Sign Up Process
- Seamless Apple ID integration
- Clean form layout with proper keyboard handling
- Real-time validation feedback
- Secure authentication flow
- Scrollable content for all screen sizes
- Trust badges for security and privacy
- Clear terms and conditions visibility
- Proper spacing and padding throughout

#### 3. Daily Limit Setup
- Interactive slider with haptic feedback
- Visual representation of limit amount
- Smart suggestions based on user input
- Clear confirmation of selected limit
- Preset quick-select buttons
- Savings projections for different timeframes

#### 4. Goal Setting
- Intelligent goal suggestions
- Interactive input validation
- Clear progress visualization
- Motivational feedback messages
- Milestone preview with timeframes
- Add multiple goals functionality

#### 5. Sports Selection
- Scrollable grid layout of available sports
- Visual feedback on selection
- Multi-select capability
- Search and filter options
- Proper spacing and touch targets
- Dynamic icons for each sport

#### 6. Features Overview
- Clear value proposition for each feature
- Organized content sections
- Proper content scrolling
- Visual hierarchy with icons and descriptions
- Pricing plans comparison
- Trial activation section

### Navigation & Progress
- Progress indicator dots at the top
- Back/Continue navigation buttons
- Smooth transitions between steps
- Proper spacing to avoid content overlap
- Clear visual feedback for current step
- Keyboard-aware adjustments

### Layout System
- Consistent padding and spacing
- Proper scroll behavior where needed
- Safe area awareness
- Optimized for all screen sizes
- Clear visual hierarchy
- Keyboard avoidance handling
- Proper content overflow management

### Dashboard
- Current Streak Display
- Total Savings
- Quick Actions
- Recent Achievements
- Transaction History
- Daily Spending Summary

### Profile Management
- Personal Information
   ```swift
   // Core Data model
   @NSManaged public var idString: String  // Unique identifier
   @NSManaged public var name: String
   @NSManaged public var email: String?
   ```
- Notification Settings
- Privacy Controls
- Data Management
- Transaction History
- Achievement Progress

## Data Management

### Core Data Integration
- Persistent storage for all user data
- Efficient querying and filtering
- Data consistency
- Background processing
- Error handling

### Transaction Management
```swift
// Core Data entity
@NSManaged public var idString: String  // UUID string
@NSManaged public var amount: Double
@NSManaged public var date: Date
@NSManaged public var note: String?
@NSManaged public var category: String

// Add new transaction
Task {
    do {
        let transaction = Transaction(
            id: UUID(),
            amount: 50.0,
            category: .savings,
            date: Date(),
            note: "Weekly savings"
        )
        try await dataManager.addTransaction(transaction)
        await MainActor.run {
            // Update UI after successful addition
            transactions.append(transaction)
        }
    } catch {
        await MainActor.run {
            errorMessage = error.localizedDescription
        }
    }
}

// Get today's transactions
@MainActor
func loadTodaysTransactions() async {
    isLoading = true
    do {
        let manager = DataManagerFactory.createDataManager()
        try await Task.sleep(nanoseconds: 100_000_000)  // Simulate network delay
        let todaysTransactions = manager.getTodaysTransactions()
        self.transactions = todaysTransactions
        isLoading = false
    } catch {
        errorMessage = error.localizedDescription
        isLoading = false
    }
}

// Calculate total spent
@MainActor
func calculateTotalSpent() async -> Double {
    do {
        let manager = DataManagerFactory.createDataManager()
        return manager.getTotalSpentToday()
    } catch {
        errorMessage = error.localizedDescription
        return 0.0
    }
}
```

### Transaction View Implementation
```swift
struct TransactionsView: View {
    @StateObject private var viewModel = TransactionsViewModel()
    @State private var isLoading = false
    @State private var showingAddTransaction = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    transactionsList
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .onAppear {
                Task {
                    await loadTransactions()
                }
            }
            .refreshable {
                await loadTransactions()
            }
        }
    }
    
    private var transactionsList: some View {
        List {
            ForEach(viewModel.transactions) { transaction in
                TransactionRow(transaction: transaction)
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await deleteTransaction(transaction)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }
    
    @MainActor
    private func loadTransactions() async {
        isLoading = true
        do {
            let manager = DataManagerFactory.createDataManager()
            try await Task.sleep(nanoseconds: 100_000_000)
            viewModel.transactions = manager.getAllTransactions().map(\.transaction)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    private func deleteTransaction(_ transaction: Transaction) async {
        do {
            try await viewModel.deleteTransaction(transaction)
            await loadTransactions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### Profile Management
```swift
// Create or update user
try CoreDataManager.shared.createOrUpdateUser(
    name: "John",
    email: "john@example.com",
    dailyLimit: 100.0
)

// Get current user
let user = CoreDataManager.shared.getCurrentUser()
```

## Monetization

### Subscription Plans
1. **Monthly Plan**
   - $9.99/month
   - All premium features
   - Cancel anytime

2. **Annual Plan**
   - $79.99/year
   - 33% savings
   - All premium features
   - Cancel anytime

### Premium Features
- Advanced Analytics
- Unlimited History
- Priority Support
- Custom Goals
- Extended Resources
- Detailed Transaction Reports
- Achievement Tracking

### Trial System
- 7-day free trial
- Full feature access
- No commitment
- Easy cancellation
- Data persistence after subscription

## Implementation Details

### State Management
```swift
public class AppState: ObservableObject {
    @Published var username: String
    @Published var currentStreak: Int
    @Published var totalSavings: Double
    @Published var dailyLimit: Double
    @Published var isOnboarded: Bool
}
```

### Data Persistence
```swift
// Core Data
private func saveToCoreData() {
    // Implementation
}
```

### Notifications
```swift
// Schedule notifications
func scheduleDailyCheckIn(at time: Date) async throws {
    // Implementation
}

func scheduleMilestoneCelebration(milestone: String) async throws {
    // Implementation
}
```

## Feature Flags
```swift
struct FeatureFlags {
    static let enableCommunity = false
    static let enableAdvancedAnalytics = false
    static let enableExtendedHistory = true
}
```

## Accessibility

### VoiceOver Support
- Meaningful labels
- Action descriptions
- Progress updates
- Achievement announcements

### Dynamic Type
- Scalable text
- Proper contrast
- Layout adaptation
- Clear hierarchy

## Analytics

### Tracked Events
1. User Engagement
   - Daily check-ins
   - Feature usage
   - Resource access
   - Achievement unlocks

2. Subscription Events
   - Trial starts
   - Conversions
   - Cancellations
   - Restorations

3. Progress Metrics
   - Streak data
   - Savings progress
   - Goal completion
   - Usage patterns

## Future Enhancements

### Planned Features
1. Community Support
   - Group challenges
   - Success sharing
   - Peer support
   - Mentorship

2. Advanced Analytics
   - Detailed insights
   - Progress predictions
   - Behavioral patterns
   - Custom reports

3. Extended Resources
   - Video content
   - Expert advice
   - Guided exercises
   - Personal coaching