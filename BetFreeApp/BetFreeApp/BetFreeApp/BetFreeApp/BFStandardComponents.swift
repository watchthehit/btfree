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
                        .font(.system(size: 14, weight: .semibold))
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
                                       [Color.gray.opacity(0.6), Color.gray.opacity(0.4)] :
                                       [BFColors.accent, BFColors.accent.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(BFCornerRadius.medium)
            .shadow(color: isDisabled ? Color.clear : BFColors.accent.opacity(0.3), 
                   radius: 8, x: 0, y: 4)
        }
        .disabled(isDisabled)
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
    var opacity: Double = 0.7
    
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
            .foregroundColor(foregroundColor.opacity(opacity))
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Card Component Extension
// Extends the existing BFCard with standardized styling

extension BFCard {
    /// Creates a card with standardized styling from the design system
    init(padding: CGFloat = BFSpacing.cardPadding, opacity: Double = 0.1, @ViewBuilder content: () -> Content) {
        self.init(content: content)
        // Pass the styling through the styledBody modifier
    }
    
    /// Returns the content with design system standard styling applied
    func styledBody(padding: CGFloat = BFSpacing.cardPadding, opacity: Double = 0.1) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(opacity))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.4), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(BFColors.accent)
                        }
                    } else {
                        Circle()
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.4), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(BFColors.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                // Option text
                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(isSelected ? 0.2 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                            .stroke(isSelected ? BFColors.accent.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Progress Bar Component

/// Standard progress bar component
struct BFProgressBar: View {
    var progress: Float
    var height: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .cornerRadius(BFCornerRadius.small)
                
                Rectangle()
                    .fill(BFColors.accent)
                    .cornerRadius(BFCornerRadius.small)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
                    .animation(.easeInOut, value: progress)
            }
        }
        .frame(height: height)
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
            
            // Text input field
            HStack(spacing: BFSpacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isFocused.wrappedValue ? BFColors.accent : .white.opacity(0.7))
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
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .fill(Color.white.opacity(0.15))
                    .shadow(color: isFocused.wrappedValue ? BFColors.accent.opacity(0.4) : Color.black.opacity(0.15), 
                           radius: isFocused.wrappedValue ? 6 : 3, 
                           x: 0, 
                           y: isFocused.wrappedValue ? 3 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                    .stroke(errorMessage != nil ? BFColors.error : (isFocused.wrappedValue ? BFColors.accent : Color.clear), lineWidth: 1.5)
            )
            
            // Error message if any
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(BFColors.error)
                    .padding(.leading, 4)
            }
        }
    }
} 