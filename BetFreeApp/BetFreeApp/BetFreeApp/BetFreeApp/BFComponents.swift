import SwiftUI

// MARK: - Button Styles

struct BFPrimaryButtonStyle: ButtonStyle {
    var isWide = false
    var size: BFButtonSize = .medium
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFTypography.button)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isWide ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? BFColors.primary.opacity(0.8) : BFColors.primary)
                    .shadow(color: BFColors.primary.opacity(0.3), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BFSecondaryButtonStyle: ButtonStyle {
    var isWide = false
    var size: BFButtonSize = .medium
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFTypography.button)
            .fontWeight(.medium)
            .foregroundColor(BFColors.primary)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isWide ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(BFColors.primary, lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(configuration.isPressed ? BFColors.primary.opacity(0.1) : Color.white)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BFTextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BFTypography.button)
            .foregroundColor(configuration.isPressed ? BFColors.primary.opacity(0.7) : BFColors.primary)
            .padding(.vertical, 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

enum BFButtonSize {
    case small, medium, large
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 12
        case .large: return 16
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 24
        case .large: return 32
        }
    }
}

// MARK: - Card View

struct BFCard<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(BFColors.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
            )
            .padding(.horizontal)
    }
}

// MARK: - Background View
struct BFBackgroundView: View {
    enum Style {
        case waves
        case circles
        case dots
    }
    
    let style: Style
    let gradient: LinearGradient
    
    var body: some View {
        ZStack {
            // Base gradient
            Rectangle()
                .fill(gradient)
                .ignoresSafeArea()
            
            // Pattern overlay
            GeometryReader { geometry in
                switch style {
                case .waves:
                    wavesPattern(in: geometry.size)
                case .circles:
                    circlesPattern(in: geometry.size)
                case .dots:
                    dotsPattern(in: geometry.size)
                }
            }
        }
    }
    
    // Wave pattern
    private func wavesPattern(in size: CGSize) -> some View {
        ZStack {
            // Multiple wave layers with different opacities
            ForEach(0..<3) { i in
                let opacity = 0.1 - Double(i) * 0.03
                
                WaveShape(amplitude: 50 + CGFloat(i * 20), 
                          frequency: 0.6 - CGFloat(i) * 0.1, 
                          phase: CGFloat(i) * 0.5)
                    .fill(Color.white.opacity(opacity))
                    .frame(height: size.height)
            }
        }
    }
    
    // Circles pattern
    private func circlesPattern(in size: CGSize) -> some View {
        ZStack {
            // Random circles
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.05 + Double.random(in: 0...0.05)))
                    .frame(width: 50 + CGFloat.random(in: 0...150),
                           height: 50 + CGFloat.random(in: 0...150))
                    .position(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height)
                    )
            }
        }
    }
    
    // Dots pattern
    private func dotsPattern(in size: CGSize) -> some View {
        ZStack {
            // Grid of dots
            ForEach(0..<Int(size.width/20), id: \.self) { x in
                ForEach(0..<Int(size.height/20), id: \.self) { y in
                    if (x + y) % 2 == 0 {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 4, height: 4)
                            .position(
                                x: CGFloat(x) * 20,
                                y: CGFloat(y) * 20
                            )
                    }
                }
            }
        }
    }
}

// Wave shape for background
struct WaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        // Start at the bottom left
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // Draw the wave
        for x in stride(from: 0, to: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * .pi * frequency * 8 + phase)
            let y = rect.height - amplitude * sine - amplitude
            path.addLine(to: CGPoint(x: x, y: max(0, y)))
        }
        
        // Complete the path
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()
        
        return Path(path.cgPath)
    }
}

// MARK: - Input Components

struct BFTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(BFTypography.bodySmall)
                .foregroundColor(BFColors.textSecondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(BFColors.textSecondary)
                        .frame(width: 20)
                }
                
                TextField(placeholder, text: $text)
                    .font(BFTypography.bodyMedium)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(BFColors.textTertiary.opacity(0.5), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Button Extensions

extension View {
    func bfPrimaryButton(isWide: Bool = false, size: BFButtonSize = .medium) -> some View {
        buttonStyle(BFPrimaryButtonStyle(isWide: isWide, size: size))
    }
    
    func bfSecondaryButton(isWide: Bool = false, size: BFButtonSize = .medium) -> some View {
        buttonStyle(BFSecondaryButtonStyle(isWide: isWide, size: size))
    }
    
    func bfTextButton() -> some View {
        buttonStyle(BFTextButtonStyle())
    }
} 