import SwiftUI

// MARK: - Text Styles

extension Text {
    func titleStyle() -> some View {
        self.font(.system(size: 24, weight: .bold))
    }
    
    func headlineStyle() -> some View {
        self.font(.system(size: 20, weight: .bold))
    }
    
    func subheadlineStyle() -> some View {
        self.font(.system(size: 18, weight: .semibold))
    }
    
    func bodyStyle() -> some View {
        self.font(.system(size: 16, weight: .regular))
    }
    
    func bodyBoldStyle() -> some View {
        self.font(.system(size: 16, weight: .semibold))
    }
    
    func smallStyle() -> some View {
        self.font(.system(size: 14, weight: .regular))
    }
    
    func smallBoldStyle() -> some View {
        self.font(.system(size: 14, weight: .semibold))
    }
    
    func captionStyle() -> some View {
        self.font(.system(size: 12, weight: .regular))
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(configuration.isPressed ? BFColors.primary.opacity(0.8) : BFColors.primary)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.system(size: 16, weight: .semibold))
            .shadow(color: BFColors.primary.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(configuration.isPressed ? BFColors.background.opacity(0.8) : BFColors.background)
            .foregroundColor(BFColors.primary)
            .cornerRadius(10)
            .font(.system(size: 16, weight: .semibold))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(BFColors.primary, lineWidth: 1.5)
            )
    }
}

struct TextButtonStyle: ButtonStyle {
    var color: Color = BFColors.primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(configuration.isPressed ? color.opacity(0.7) : color)
    }
}

extension Button {
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButtonStyle() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    func textButtonStyle(color: Color = BFColors.primary) -> some View {
        self.buttonStyle(TextButtonStyle(color: color))
    }
}

// MARK: - Card Components

struct BFCard<Content: View>: View {
    var content: Content
    var padding: CGFloat = 16
    
    init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(BFColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: BFColors.primary.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Progress Components

struct BFProgressCircle: View {
    var progress: Double
    var size: CGFloat
    var lineWidth: CGFloat
    var gradient: LinearGradient
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.1)
                .foregroundColor(BFColors.primary)
            
            // Progress Circle
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .fill(gradient)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            // Percentage Text
            VStack(spacing: 2) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size/5, weight: .bold))
                    .foregroundColor(BFColors.textPrimary)
                
                Text("Complete")
                    .font(.system(size: size/8))
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .frame(width: size, height: size)
    }
}

struct BFProgressBar: View {
    var progress: Double
    var height: CGFloat = 8
    var gradient: LinearGradient
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height/2)
                    .frame(width: geometry.size.width, height: height)
                    .opacity(0.1)
                    .foregroundColor(BFColors.primary)
                
                // Progress
                RoundedRectangle(cornerRadius: height/2)
                    .frame(width: geometry.size.width * CGFloat(min(self.progress, 1.0)), height: height)
                    .fill(gradient)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Input Components

struct BFTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(BFColors.textSecondary)
                    .frame(width: 24)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(BFColors.background)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(BFColors.divider, lineWidth: 1)
        )
    }
}

// MARK: - Badge Components

struct BFBadge: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .smallBoldStyle()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

// MARK: - Helper Components

struct BFEmptyStateView: View {
    var icon: String
    var title: String
    var message: String
    var buttonText: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(BFColors.textTertiary)
            
            Text(title)
                .headlineStyle()
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(message)
                .bodyStyle()
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
            
            if let buttonText = buttonText, let action = action {
                Button(action: action) {
                    Text(buttonText)
                }
                .primaryButtonStyle()
                .padding(.top, 10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Analytics Dashboard Components

struct BFStatItem: View {
    var title: String
    var value: String
    var icon: String? = nil
    var color: Color = BFColors.primary
    
    var body: some View {
        VStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
            
            Text(title)
                .smallStyle()
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 100)
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Animation Helper

struct BFAnimatedCheckmark: View {
    @State private var trimEnd: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(BFColors.success.opacity(0.2))
                .frame(width: 80, height: 80)
            
            Circle()
                .strokeBorder(BFColors.success, lineWidth: 3)
                .frame(width: 80, height: 80)
            
            Path { path in
                path.move(to: CGPoint(x: 30, y: 45))
                path.addLine(to: CGPoint(x: 40, y: 55))
                path.addLine(to: CGPoint(x: 55, y: 30))
            }
            .trim(from: 0, to: trimEnd)
            .stroke(BFColors.success, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                trimEnd = 1
            }
        }
    }
} 