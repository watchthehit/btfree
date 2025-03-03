import SwiftUI

/**
 * BFStandardComponents - Standardized UI components for the BetFree app
 * 
 * This file provides consistent components to be used across all screens
 * to maintain visual coherence and reduce development time.
 */

// MARK: - Standard Buttons

/// Primary button with consistent styling across the app
struct BFPrimaryButton: View {
    var text: String
    var icon: String? = nil
    var action: () -> Void
    var isDisabled: Bool = false
    var fullWidth: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.small) {
                Text(text)
                    .font(.system(size: 18, weight: .semibold))
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(height: 24)
            .padding(.vertical, 16)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, fullWidth ? 0 : 30)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDisabled ? 
                                       [Color.gray.opacity(0.8), Color.gray.opacity(0.6)] :
                                       [BFColors.accent, BFColors.accent.opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(BFCornerRadius.medium)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .stroke(isDisabled ? Color.clear : Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isDisabled ? Color.clear : BFColors.accent.opacity(0.5), 
                   radius: 10, x: 0, y: 4)
        }
        .disabled(isDisabled)
        .accessibilityLabel(text)
    }
}

/// Secondary button with consistent styling across the app
struct BFSecondaryButton: View {
    var text: String
    var icon: String? = nil
    var action: () -> Void
    var isDisabled: Bool = false
    var fullWidth: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.small) {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .foregroundColor(isDisabled ? Color.gray.opacity(0.6) : BFColors.textPrimary)
            .frame(height: 24)
            .padding(.vertical, 14)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, fullWidth ? 0 : 24)
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .stroke(isDisabled ? Color.gray.opacity(0.3) : BFColors.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(isDisabled)
    }
}

/// Text button (no background) with consistent styling
struct BFTextButton: View {
    var text: String
    var icon: String? = nil
    var action: () -> Void
    var foregroundColor: Color = .white
    var opacity: Double = 0.9
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.small) {
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .foregroundColor(foregroundColor.opacity(opacity))
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.1))
                    .padding(.horizontal, -6)
            )
            .contentShape(Rectangle())
            .accessibilityLabel(text)
        }
    }
}

// MARK: - Card Component Extension
// Extends the existing BFCard with standardized styling

extension BFCard {
    /// Creates a card with standardized styling from the design system
    func styledBody(padding: EdgeInsets = EdgeInsets(top: BFSpacing.medium, leading: BFSpacing.medium, bottom: BFSpacing.medium, trailing: BFSpacing.medium), 
                   opacity: Double = 0.95) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(opacity))
                    .shadow(
                        color: Color.black.opacity(0.15),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            )
    }
    
    /// Creates a card with more prominent styling for important content
    func prominentStyle(padding: EdgeInsets = EdgeInsets(top: BFSpacing.medium, leading: BFSpacing.medium, bottom: BFSpacing.medium, trailing: BFSpacing.medium)) -> some View {
        self
            .padding(padding)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                        .fill(Color.white.opacity(0.3))
                    
                    RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                        .stroke(BFColors.accent.opacity(0.4), lineWidth: 1.5)
                }
                .shadow(
                    color: Color.black.opacity(0.15),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            )
    }
}

// MARK: - Standard Screen Background

/// Standard background for screens
struct BFScreenBackground: View {
    var body: some View {
        BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
            .ignoresSafeArea()
    }
}

// MARK: - Option Button Component

/// Standard option button for selections
struct BFOptionButton: View {
    var text: String
    var isSelected: Bool
    var allowsMultiple: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFSpacing.medium) {
                // Selection indicator
                ZStack {
                    if allowsMultiple {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.7), lineWidth: 2)
                            .frame(minWidth: 22, minHeight: 22, alignment: .center)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(BFColors.accent)
                        }
                    } else {
                        Circle()
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.7), lineWidth: 2)
                            .frame(minWidth: 22, minHeight: 22, alignment: .center)
                        
                        if isSelected {
                            Circle()
                                .fill(BFColors.accent)
                                .frame(minWidth: 14, minHeight: 14, alignment: .center)
                        }
                    }
                }
                .accessibilityHidden(true)
                
                // Option text
                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(Color(hex: "#1B263B"))
                
                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(isSelected ? 0.95 : 0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                            .stroke(isSelected ? BFColors.accent.opacity(0.7) : Color.white.opacity(0.5), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: isSelected ? BFColors.accent.opacity(0.3) : Color.black.opacity(0.1), 
                           radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - Progress Bar Component

/// Standard progress bar component
struct BFProgressBar: View {
    var progress: Float
    var height: CGFloat = 6
    var showPercentage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .cornerRadius(BFCornerRadius.small)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(BFCornerRadius.small)
                        .frame(width: max(8, CGFloat(max(0, progress)) * max(0, geometry.size.width - 64))
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: height)
            .accessibilityValue("\(Int(progress * 100)) percent")
        }
    }
}

// MARK: - TextField Component Extension
// Extends the existing BFTextField with enhanced styling

extension BFTextField {
    /// Creates a text field with enhanced styling from the design system
    func enhanced(isFocused: FocusState<Bool>.Binding, errorMessage: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: BFSpacing.tiny) {
            // Field label
            Text(title)
                .font(BFTypography.bodySmall)
                .foregroundColor(.white)
                .fontWeight(.semibold)
            
            // Text input field
            HStack(spacing: BFSpacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isFocused.wrappedValue ? BFColors.accent : .white.opacity(0.9))
                        .font(.system(size: 16))
                }
                
                TextField(placeholder, text: $text)
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused(isFocused)
                    .tint(BFColors.accent)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white.opacity(0.7))
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(0.3))
                    .shadow(color: isFocused.wrappedValue ? BFColors.accent.opacity(0.5) : Color.black.opacity(0.2), 
                           radius: isFocused.wrappedValue ? 6 : 3, 
                           x: 0, 
                           y: isFocused.wrappedValue ? 3 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .stroke(errorMessage != nil ? BFColors.error : (isFocused.wrappedValue ? BFColors.accent : Color.white.opacity(0.5)), lineWidth: 2)
            )
            
            // Error message if any
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(BFColors.error)
                    .padding(.leading, 4)
                    .accessibilityLabel("Error: \(errorMessage)")
            }
        }
    }
}

// Helper extension for placeholder styling
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Dashboard Card Components

/// A modern dashboard card component inspired by PuffCount's minimal UI style
struct BFDashboardCard<Content: View>: View {
    var title: String
    var icon: String? = nil
    var iconColor: Color = BFColors.accent
    var showBadge: Bool = false
    var badgeText: String = ""
    var badgeColor: Color = BFColors.accent
    var content: Content
    
    init(title: String, 
         icon: String? = nil, 
         iconColor: Color = BFColors.accent,
         showBadge: Bool = false,
         badgeText: String = "",
         badgeColor: Color = BFColors.accent,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.showBadge = showBadge
        self.badgeText = badgeText
        self.badgeColor = badgeColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                        .frame(minWidth: 28, minHeight: 28, alignment: .center)
                        .background(
                            Circle()
                                .fill(iconColor.opacity(0.15))
                        )
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#1B263B"))
                
                Spacer()
                
                if showBadge {
                    Text(badgeText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(badgeColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(badgeColor.opacity(0.15))
                        )
                }
            }
            
            // Content
            content
                .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.96))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

/// A stat item component for use within dashboard cards
struct BFStatItem: View {
    var title: String
    var value: String
    var subtitle: String? = nil
    var valueColor: Color = BFColors.primary
    var icon: String? = nil
    var iconColor: Color = BFColors.accent
    var showTrend: Bool = false
    var trendUp: Bool = false
    var trendValue: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
            
            HStack(alignment: .bottom, spacing: 8) {
                // Value
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(valueColor)
                
                // Trend if shown
                if showTrend {
                    HStack(spacing: 2) {
                        Image(systemName: trendUp ? "arrow.up" : "arrow.down")
                            .font(.system(size: 12))
                            .foregroundColor(trendUp ? BFColors.success : BFColors.error)
                        
                        Text(trendValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(trendUp ? BFColors.success : BFColors.error)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill((trendUp ? BFColors.success : BFColors.error).opacity(0.1))
                    )
                    .padding(.bottom, 4)
                }
                
                Spacer()
                
                // Icon if provided
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                        .frame(minWidth: 32, minHeight: 32, alignment: .center)
                        .background(
                            Circle()
                                .fill(iconColor.opacity(0.1))
                        )
                }
            }
            
            // Subtitle if provided
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#1B263B").opacity(0.6))
                    .padding(.top, 2)
            }
        }
    }
}

/// A modern progress stat component inspired by PuffCount
struct BFProgressStat: View {
    var title: String
    var currentValue: Double
    var targetValue: Double
    var units: String = ""
    var color: Color = BFColors.accent
    
    private var percentage: Double {
        min(currentValue / targetValue, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and values
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
                
                Spacer()
                
                Text("\(Int(currentValue)) / \(Int(targetValue)) \(units)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#1B263B"))
            }
            
            // Progress bar
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 8)
                
                // Fill
                let progressWidth = max(8, CGFloat(max(0, percentage)) * (UIScreen.main.bounds.width - 64))
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: progressWidth, height: 8)
            }
            
            // Percentage text
            Text("\(Int(percentage * 100))% Complete")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
        }
    }
}

// Example usage of the new dashboard components:
// BFDashboardCard(title: "Weekly Progress", icon: "chart.bar.fill") {
//     BFStatItem(
//         title: "Days Without Gambling", 
//         value: "5", 
//         subtitle: "Personal best: 14 days",
//         showTrend: true, 
//         trendUp: true, 
//         trendValue: "40%"
//     )
//     
//     BFProgressStat(
//         title: "Weekly Goal", 
//         currentValue: 5, 
//         targetValue: 7, 
//         units: "days"
//     )
// }

/// A tap counter button inspired by PuffCount's minimalist design
struct BFCounterButton: View {
    var count: Int
    var title: String
    var subtitle: String
    var incrementAction: () -> Void
    var resetAction: () -> Void
    var color: Color = BFColors.accent
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#1B263B"))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            // Counter circle button
            ZStack {
                // Background circle
                Circle()
                    .fill(color.opacity(0.07))
                    .frame(minWidth: 180, minHeight: 180, alignment: .center)
                
                // Middle circle with subtle gradient
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(isPressed ? 0.3 : 0.15),
                                color.opacity(isPressed ? 0.2 : 0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minWidth: 150, minHeight: 150, alignment: .center)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
                
                // Counter text
                VStack(spacing: 6) {
                    Text("\(count)")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(Color(hex: "#1B263B"))
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                // Visual feedback
                withAnimation {
                    isPressed = true
                }
                // Haptic feedback
                let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
                impactGenerator.impactOccurred()
                
                // Increment counter
                incrementAction()
                
                // Reset visual state
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        isPressed = false
                    }
                }
            }
            .onLongPressGesture(minimumDuration: 1.5) {
                // Haptic feedback
                let impactGenerator = UINotificationFeedbackGenerator()
                impactGenerator.notificationOccurred(.success)
                
                // Reset counter
                resetAction()
            }
            
            // Hint for resetting
            Text("Long press to reset")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#1B263B").opacity(0.5))
                .padding(.bottom, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.97))
                .shadow(color: Color.black.opacity(0.07), radius: 15, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

/// A clean bar chart component inspired by PuffCount's data visualization
struct BFBarChart: View {
    struct DataPoint {
        var value: Double
        var label: String
        var color: Color = BFColors.accent
    }
    
    var title: String
    var subtitle: String? = nil
    var dataPoints: [DataPoint]
    var maxValue: Double? = nil
    
    private var calculatedMaxValue: Double {
        maxValue ?? (dataPoints.map { $0.value }.max() ?? 0) * 1.2
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#1B263B"))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#1B263B").opacity(0.6))
                }
            }
            
            // Chart
            VStack(spacing: 24) {
                // Bars
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        VStack(spacing: 8) {
                            // Value text
                            Text("\(Int(dataPoints[index].value))")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(dataPoints[index].color)
                                .opacity(dataPoints[index].value > 0 ? 1 : 0)
                                .frame(height: 14)
                            
                            // Bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            dataPoints[index].color,
                                            dataPoints[index].color.opacity(0.7)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: dataPoints[index].value > 0 
                                       ? CGFloat(dataPoints[index].value / calculatedMaxValue) * 150
                                       : 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(dataPoints[index].color.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: dataPoints[index].color.opacity(0.2), radius: 2, x: 0, y: 2)
                                .animation(.easeOut(duration: 0.5), value: dataPoints[index].value)
                            
                            // Label text
                            Text(dataPoints[index].label)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
                                .frame(height: 14)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 10)
                
                // Bottom line
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
            }
            .padding(.top, 10)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.97))
                .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

/// A streak counter component inspired by PuffCount's achievement tracking
struct BFStreakCounter: View {
    var streakCount: Int
    var streakLabel: String
    var bestStreak: Int
    var showFireIcon: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            // Current streak header
            HStack {
                Text("Current Streak")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#1B263B"))
                
                Spacer()
                
                if showFireIcon && streakCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundColor(BFColors.accent)
                        
                        Text("\(streakCount)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BFColors.accent)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(BFColors.accent.opacity(0.1))
                    )
                }
            }
            
            // Main streak counter
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("\(streakCount)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(streakCount > 0 ? BFColors.accent : Color(hex: "#1B263B"))
                    
                    Text(streakLabel)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Best")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#1B263B").opacity(0.6))
                    
                    Text("\(bestStreak)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#1B263B"))
                }
                .padding(.bottom, 8)
            }
            
            // Day circles
            HStack(spacing: 12) {
                ForEach(1...7, id: \.self) { day in
                    VStack(spacing: 6) {
                        // Circle
                        ZStack {
                            Circle()
                                .fill(day <= streakCount ? BFColors.accent : Color.gray.opacity(0.1))
                                .frame(minWidth: 26, minHeight: 26, alignment: .center)
                            
                            if day <= streakCount {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Day label
                        Text("\(day)")
                            .font(.system(size: 12))
                            .foregroundColor(day <= streakCount ? BFColors.accent : Color(hex: "#1B263B").opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.top, 6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.97))
                .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
        )
    }
} 