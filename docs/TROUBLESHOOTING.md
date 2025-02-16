# BetFree Troubleshooting Guide

This guide covers common issues you might encounter while developing the BetFree app and their solutions.

## Table of Contents
1. [Common Issues](#common-issues)
2. [Build Issues](#build-issues)
3. [Runtime Issues](#runtime-issues)
4. [Testing Issues](#testing-issues)
5. [Performance Issues](#performance-issues)
6. [Debugging Tips](#debugging-tips)

## Common Issues

### SwiftUI ProgressView Naming Conflict
**Issue**: Compiler error when using `ProgressView`
**Solution**: Use explicit SwiftUI namespace
```swift
// ❌ Will not compile
ProgressView(value: progressValue)

// ✅ Use explicit namespace
SwiftUI.ProgressView(value: progressValue)
```

### Core Data Threading Issues
**Issue**: Crashes when accessing Core Data from background threads or improper async/await usage
**Solution**: Use proper async/await patterns and MainActor
```swift
// ❌ Don't do this
backgroundQueue.async {
    let context = CoreDataManager.shared.context
}

// ❌ Don't do this either
func loadTransactions() {
    Task {
        await loadData()  // Missing error handling
    }
}

// ✅ Do this
@MainActor
func loadTransactions() async {
    isLoading = true  // UI update on MainActor
    do {
        let manager = MockCDManager.shared
        try await Task.sleep(nanoseconds: 100_000_000)  // Simulate async
        let transactions = manager.getAllTransactions().map(\.transaction)
        self.transactions = transactions  // UI update on MainActor
        isLoading = false
    } catch {
        print("Error loading transactions: \(error)")
        isLoading = false
    }
}

// ✅ And call it like this
.onAppear {
    Task {
        await loadTransactions()
    }
}
```

### ResourcesView Access Issues
**Issue**: Duplicate view declarations
**Solution**: Import and use existing view
```swift
// ❌ Don't redeclare
struct ResourcesView: View { ... }

// ✅ Import and use
import BetFree
// Use ResourcesView directly
```

### Transaction Management Issues
**Issue**: Improper transaction handling and state updates
**Solution**: Use proper async patterns and state management
```swift
// ❌ Don't modify transactions directly
transaction.amount = newAmount
transaction.save()

// ❌ Don't update UI state from background
Task {
    let transactions = await loadTransactions()
    self.transactions = transactions  // Wrong thread
}

// ✅ Do use proper async/await with MainActor
@MainActor
func updateTransaction(_ transaction: Transaction, amount: Double) async throws {
    isLoading = true
    do {
        try await dataManager.updateTransaction(transaction, amount: amount)
        await loadTransactions()  // Refresh list
    } catch {
        errorMessage = error.localizedDescription
    }
    isLoading = false
}

// ✅ Do update UI state on MainActor
Task {
    await MainActor.run {
        isLoading = true
    }
    do {
        let transactions = await loadTransactions()
        await MainActor.run {
            self.transactions = transactions
            isLoading = false
        }
    } catch {
        await MainActor.run {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
```

### Common Async/Await Pitfalls
1. **Missing Error Handling**
```swift
// ❌ Don't ignore errors
Task {
    await loadData()  // What if this fails?
}

// ✅ Do handle errors properly
Task {
    do {
        try await loadData()
    } catch {
        await MainActor.run {
            errorMessage = error.localizedDescription
        }
    }
}
```

2. **Improper Task Usage**
```swift
// ❌ Don't create unnecessary nested tasks
Task {
    Task {  // Unnecessary nesting
        await doSomething()
    }
}

// ✅ Do use a single task
Task {
    await doSomething()
}
```

3. **Wrong Actor Context**
```swift
// ❌ Don't assume context
func updateUI() {  // No @MainActor
    self.isLoading = false  // Might crash
}

// ✅ Do specify actor context
@MainActor
func updateUI() {
    self.isLoading = false  // Safe
}
```

## Build Issues

### Package Resolution Failures
**Steps to resolve**:
1. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
2. Clean build folder (Cmd + Shift + K)
3. Reset package caches:
   - File > Packages > Reset Package Caches
4. Update package dependencies:
   - File > Packages > Update to Latest Package Versions

### Compilation Errors
**Common fixes**:
1. Check module imports
2. Verify access levels (public/internal)
3. Ensure MainActor usage for UI updates
4. Validate Core Data model versions

### Runtime Crashes
**Common solutions**:
1. Verify Core Data migrations
2. Check thread safety with @MainActor
3. Validate optional unwrapping
4. Ensure proper initialization order

## Runtime Issues

### State Management
**Issue**: UI not updating
**Solution**: Ensure proper state management
```swift
// ❌ Don't update state from background
DispatchQueue.global().async {
    self.someState = newValue  // Will crash
}

// ✅ Use MainActor
@MainActor
func updateState() {
    self.someState = newValue
}
```

### Memory Management
**Issue**: Memory leaks
**Solution**: Use weak references
```swift
// ❌ Strong reference cycle
class SomeManager {
    var handler: (() -> Void)?
}

// ✅ Weak reference
class SomeManager {
    weak var delegate: SomeDelegate?
}
```

## Testing Issues

### Mock Data Usage
**Issue**: Tests affecting production data
**Solution**: Use mock data manager
```swift
// ❌ Don't use production manager
let manager = CoreDataManager.shared

// ✅ Use mock manager
let manager = MockCDManager()
```

### UI Testing
**Issue**: Inconsistent test data
**Solution**: Use launch arguments
```swift
// ❌ Don't hardcode
if isUITesting {
    username = "test"
}

// ✅ Use launch arguments
if CommandLine.arguments.contains("--uitesting") {
    username = ProcessInfo.processInfo.environment["TEST_USERNAME"]
}
```

## Performance Issues

### Core Data Optimization
**Issue**: Slow data fetching
**Solution**: Use batch fetching
```swift
// ❌ Don't fetch everything
let allRecords = try context.fetch(request)

// ✅ Use batch fetching
request.fetchBatchSize = 20
request.fetchLimit = 50
```

### Memory Optimization
**Issue**: High memory usage
**Solution**: Implement proper cleanup
```swift
// ❌ Don't keep references
var allData: [LargeObject] = []

// ✅ Use lazy loading
lazy var data: [LargeObject] = loadData()
```

## Debugging Tips

### Core Data Debugging
Enable SQL debugging:
```bash
# Add to scheme arguments
-com.apple.CoreData.SQLDebug 1
```

### View Debugging
Visualize view boundaries:
```swift
someView
    .border(Color.red)  // Show boundaries
    .background(Color.blue.opacity(0.2))  // Check layout
```

### State Debugging
Track state changes:
```swift
@Published var someState: String {
    willSet { print("State changing from \(someState) to \(newValue)") }
    didSet { print("State changed to \(someState)") }
}
```

## Common Error Messages

### "Invalid redeclaration"
- Check for duplicate type declarations
- Verify module imports
- Ensure proper access levels

### "Thread-related crash"
- Add @MainActor to view models
- Use async/await for Core Data
- Dispatch UI updates to main thread

### "Core Data constraint failure"
- Verify unique constraints
- Check relationship rules
- Validate data before saving

### "View identity error"
- Ensure proper ForEach identifiers
- Use stable IDs for list items
- Avoid changing view identity

### "Unrecognized selector sent to instance"
**Issue**: Core Data entity property not found
**Common case**: "-[UserProfileEntity setIdString:]: unrecognized selector"

**Solutions**:
1. Check Core Data model:
   - Verify property exists in `.xcdatamodeld`
   - Ensure model is up to date
   - Check property name matches exactly
   - Required attributes for UserProfileEntity:
     ```swift
     idString: String (non-optional, default: "")
     name: String (non-optional, default: "")
     email: String? (optional)
     dailyLimit: Double (non-optional, default: 0.0)
     streak: Int32 (non-optional, default: 0)
     totalSavings: Double (non-optional, default: 0.0)
     lastCheckIn: Date? (optional)
     ```

2. Check entity class:
   ```swift
   // ❌ Property doesn't exist in Core Data model
   userProfile.idString = "some-id"  // Crashes
   
   // ✅ Verify property exists first
   if userProfile.entity.propertiesByName["idString"] != nil {
       userProfile.idString = "some-id"
   }
   ```

3. Common fixes:
   - Clean build folder
   - Delete derived data
   - Check Core Data model version
   - Verify `NSManagedObject` subclass generation
   - Ensure all required attributes are present in model

4. For logout specifically:
   ```swift
   // ❌ Don't modify Core Data objects after deletion
   func logout() {
       userProfile.idString = nil  // Crashes
       context.delete(userProfile)
   }
   
   // ✅ Delete object first, then clean up state
   func logout() {
       if let userProfile = getCurrentUser() {
           context.delete(userProfile)
           try? context.save()
       }
       // Reset app state after deletion
       resetAppState()
   }
   ```

## Quick Reference

### Debug Commands
```bash
# Enable Core Data debugging
-com.apple.CoreData.SQLDebug 1

# Enable view debugging
-UIViewLayoutFeedbackLoopDebugging YES

# Enable memory debugging
-com.apple.CoreData.ConcurrencyDebug 1
```

### Common Solutions
1. **UI Not Updating**
   - Check @MainActor usage
   - Verify @Published properties
   - Ensure proper ObservableObject conformance

2. **Core Data Issues**
   - Verify context thread
   - Check save operations
   - Validate model relationships

3. **Memory Issues**
   - Use weak references
   - Implement proper cleanup
   - Monitor memory usage

4. **Performance Issues**
   - Use batch operations
   - Implement lazy loading
   - Monitor CPU usage

### Core Data Reset Issues
**Issue**: Unrecognized selector after batch delete
**Solution**: Properly handle in-memory objects during reset

```swift
// ❌ Don't use batch delete without handling in-memory objects
func reset() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    try? context.execute(deleteRequest)  // Objects still in memory!
}

// ✅ Do properly delete and reset context
func reset() {
    let request = NSFetchRequest<Entity>(entityName: "Entity")
    do {
        // Delete each object properly
        let objects = try context.fetch(request)
        for object in objects {
            context.delete(object)
        }
        
        // Save changes
        try context.save()
        
        // Reset context to ensure clean state
        context.reset()
    } catch {
        print("Error resetting: \(error)")
    }
}
```

This ensures:
1. All objects are properly deleted
2. In-memory objects are cleaned up
3. Context is in a clean state
4. No dangling references remain

### Common Scroll View Issues
**Issue**: Content not scrollable or cut off
**Solution**: Wrap content in ScrollView and ensure proper layout
```swift
// ❌ Content might be cut off
VStack {
    // Long content...
}

// ✅ Content is scrollable
ScrollView(showsIndicators: false) {
    VStack {
        // Long content...
    }
}
```

### Keyboard Handling
**Issue**: Keyboard covers input fields
**Solution**: Use proper keyboard handling and scroll adjustment
```swift
// ❌ Keyboard might cover fields
TextField("Email", text: $email)

// ✅ Proper keyboard handling
ScrollView {
    VStack {
        TextField("Email", text: $email)
            .textFieldStyle(OnboardingTextFieldStyle())
    }
    .padding(.bottom, 32) // Extra padding for keyboard
}
```

### Layout Issues
**Issue**: Content overlapping with safe areas
**Solution**: Respect safe area insets and use proper padding
```swift
// ❌ Content might overlap with safe areas
VStack {
    Text("Title")
}

// ✅ Proper safe area handling
GeometryReader { geometry in
    VStack {
        Text("Title")
            .padding(.top, geometry.safeAreaInsets.top + 16)
    }
}
```

### Content Visibility
**Issue**: Important content not visible or accessible
**Solution**: Ensure proper spacing and scrolling
```swift
// ❌ Terms might be hidden
VStack {
    // Form fields...
    Text("Terms and Conditions")
}

// ✅ Terms always visible
ScrollView {
    VStack {
        // Form fields...
        Text("Terms and Conditions")
            .padding(.bottom, 32)
    }
}
```

## Common Issues and Solutions

### Design System

#### Shadow Usage
**Issue**: Cannot convert value of type 'ViewShadow' to expected argument type 'Color'
```swift
.withShadow(BFDesignSystem.Layout.Shadow.card) // ❌ Wrong
```

**Solution**: Use the `withViewShadow` modifier instead:
```swift
.withViewShadow(BFDesignSystem.Layout.Shadow.card) // ✅ Correct
```

#### Color Usage
**Issue**: Type 'BFDesignSystem.Colors' has no member 'secondary'
```swift
.foregroundColor(BFDesignSystem.Colors.secondary) // ❌ Wrong
```

**Solution**: Use `textSecondary` for secondary text colors:
```swift
.foregroundColor(BFDesignSystem.Colors.textSecondary) // ✅ Correct
```

#### Typography Usage
**Issue**: Type 'BFDesignSystem.Typography' has no member 'body'
```swift
.font(BFDesignSystem.Typography.body) // ❌ Wrong
```

**Solution**: Use the appropriate typography scale:
```swift
.font(BFDesignSystem.Typography.bodyMedium) // ✅ Correct
```

### Swift 6 Compatibility

#### Optional Enum Handling
**Issue**: Switch covers known cases, but enum may have additional unknown values
```swift
switch colorScheme {
case .dark: // ...
case .light: // ...
case .none: // ...
} // ❌ Wrong
```

**Solution**: Add a catch-all case for future values:
```swift
switch colorScheme {
case .dark: // ...
case .light: // ...
case .none: // ...
case .some(_): // Handle future cases
} // ✅ Correct
```

### Best Practices

1. Always use design system colors instead of hard-coded values
2. Use semantic color names (e.g., `textSecondary` instead of `secondary`)
3. Use the typography scale for consistent text styling
4. Handle future enum cases for Swift 6 compatibility
5. Use proper shadow modifiers with ViewShadow type

### Common Warnings

1. "Use of 'Color' refers to instance method rather than struct": Use proper color helpers
2. "Cannot convert ViewShadow to Color": Use withViewShadow modifier
3. "Type has no member": Check design system documentation for correct property names
4. "Switch must be exhaustive": Add catch-all case for future enum values
