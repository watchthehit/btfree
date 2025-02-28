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

// MARK: - Background Views

struct BFBackgroundView: View {
    enum Style {
        case plain, waves, circles
    }
    
    var style: Style
    var gradient: LinearGradient = BFColors.calmGradient()
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            switch style {
            case .plain:
                EmptyView()
            case .waves:
                WavesView()
                    .opacity(0.1)
                    .ignoresSafeArea()
            case .circles:
                CirclesView()
                    .opacity(0.1)
                    .ignoresSafeArea()
            }
        }
    }
}

private struct WavesView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                sineWave(frequency: Double(i + 1) * 0.5, phase: phase)
                    .stroke(Color.white, lineWidth: 3.0 - Double(i) * 0.5)
                    .opacity(0.5 - Double(i) * 0.1)
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
    
    func sineWave(frequency: Double, phase: CGFloat) -> Path {
        Path { path in
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            let midHeight = height / 2
            let amplitude = height * 0.1
            
            path.move(to: CGPoint(x: 0, y: midHeight))
            
            for x in stride(from: 0, through: width, by: 5) {
                let relativeX = x / width
                let sine = sin(2 * .pi * Double(relativeX) * frequency + Double(phase))
                let y = midHeight + CGFloat(sine) * amplitude
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}

private struct CirclesView: View {
    let circles = 6
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ForEach(0..<circles, id: \.self) { i in
                Circle()
                    .stroke(Color.white, lineWidth: 1.5)
                    .scaleEffect(scale - CGFloat(i) * 0.05)
                    .opacity(0.4 - Double(i) * 0.05)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
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