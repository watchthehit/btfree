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

### Onboarding Flow
1. Welcome Screen
2. Personal Info Collection
   ```swift
   // Core Data model
   @NSManaged public var name: String
   @NSManaged public var email: String?
   ```
3. Goal Setting
4. Daily Limit Setup
5. Subscription Options

### Dashboard
- Current Streak Display
- Total Savings
- Quick Actions
- Recent Achievements
- Transaction History
- Daily Spending Summary

### Resource Center
- Educational Content
- Support Resources
- Success Stories
- Emergency Contacts

### Profile Management
- Personal Information
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
// Add new transaction
try CoreDataManager.shared.addTransaction(
    amount: 50.0,
    note: "Weekly savings"
)

// Get today's transactions
let transactions = CoreDataManager.shared.getTodaysTransactions()

// Calculate total spent
let total = CoreDataManager.shared.getTotalSpentToday()
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