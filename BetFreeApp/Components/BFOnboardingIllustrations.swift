import SwiftUI

/**
 * BFOnboardingIllustrations
 * A collection of custom illustrations for onboarding screens
 * Built with pure SwiftUI shapes and animations to match the BetFree branding
 */
struct BFOnboardingIllustrations {
    
    // MARK: - Breaking Free Illustration
    struct BreakingFree: View {
        var size: CGFloat = 200
        @State private var isAnimating = false
        
        var body: some View {
            ZStack {
                // Background circles
                Circle()
                    .stroke(BFColors.deepSpaceBlue.opacity(0.2), lineWidth: size * 0.01)
                    .frame(width: size * 0.9, height: size * 0.9)
                
                // Broken chain link concept
                ZStack {
                    // Left side of broken chain
                    Path { path in
                        path.addArc(
                            center: CGPoint(x: size * 0.3, y: size * 0.5),
                            radius: size * 0.15,
                            startAngle: .degrees(0),
                            endAngle: .degrees(270),
                            clockwise: true
                        )
                        path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.65))
                    }
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.oxfordBlue,
                                BFColors.deepSpaceBlue
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: size * 0.05, lineCap: .round)
                    )
                    
                    // Right side of broken chain
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.7, y: size * 0.35))
                        path.addArc(
                            center: CGPoint(x: size * 0.7, y: size * 0.5),
                            radius: size * 0.15,
                            startAngle: .degrees(270),
                            endAngle: .degrees(180),
                            clockwise: true
                        )
                    }
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.oxfordBlue,
                                BFColors.deepSpaceBlue
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: size * 0.05, lineCap: .round)
                    )
                }
                .offset(y: isAnimating ? -size * 0.02 : size * 0.02)
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                // Freedom symbol (modified strength circle)
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .rotation(.degrees(90))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.vibrantTeal,
                                BFColors.oceanBlue
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: size * 0.04, lineCap: .round)
                    )
                    .frame(width: size * 0.45, height: size * 0.45)
                    .shadow(color: BFColors.vibrantTeal.opacity(0.4), radius: size * 0.04)
                    .offset(y: isAnimating ? size * 0.02 : -size * 0.02)
                    .animation(
                        Animation.easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .frame(width: size, height: size)
            .onAppear {
                isAnimating = true
            }
        }
    }
    
    // MARK: - Growth Journey Illustration
    struct GrowthJourney: View {
        var size: CGFloat = 200
        @State private var isAnimating = false
        @State private var growthProgress: CGFloat = 0.0
        
        var body: some View {
            ZStack {
                // Background gradient
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                BFColors.deepSpaceBlue.opacity(0.1),
                                BFColors.deepSpaceBlue.opacity(0.0)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.5
                        )
                    )
                    .frame(width: size, height: size)
                
                // Path element
                ZStack {
                    // Path base
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.2, y: size * 0.8))
                        path.addCurve(
                            to: CGPoint(x: size * 0.8, y: size * 0.3),
                            control1: CGPoint(x: size * 0.4, y: size * 0.7),
                            control2: CGPoint(x: size * 0.7, y: size * 0.5)
                        )
                    }
                    .stroke(
                        BFColors.oceanBlue.opacity(0.3),
                        style: StrokeStyle(lineWidth: size * 0.03, lineCap: .round)
                    )
                    
                    // Animated path that grows
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.2, y: size * 0.8))
                        path.addCurve(
                            to: CGPoint(x: size * 0.8, y: size * 0.3),
                            control1: CGPoint(x: size * 0.4, y: size * 0.7),
                            control2: CGPoint(x: size * 0.7, y: size * 0.5)
                        )
                    }
                    .trim(from: 0, to: growthProgress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.vibrantTeal,
                                BFColors.oceanBlue
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: size * 0.03, lineCap: .round)
                    )
                    
                    // Progress indicator dot
                    Circle()
                        .fill(BFColors.vibrantTeal)
                        .frame(width: size * 0.08, height: size * 0.08)
                        .shadow(color: BFColors.vibrantTeal.opacity(0.5), radius: size * 0.02)
                        .offset(
                            x: getPositionAlongPath(progress: growthProgress).x - size * 0.5,
                            y: getPositionAlongPath(progress: growthProgress).y - size * 0.5
                        )
                }
                
                // Growth elements - stylized plants/upward elements
                VStack(spacing: 0) {
                    // Strength circle 
                    Circle()
                        .trim(from: 0.1, to: 0.9)
                        .rotation(.degrees(90))
                        .fill(BFColors.vibrantTeal.opacity(0.8))
                        .frame(width: size * 0.1, height: size * 0.1)
                        .offset(x: size * 0.3)
                        .scaleEffect(isAnimating ? 1 : 0.7)
                }
                .offset(y: -size * 0.15)
            }
            .frame(width: size, height: size)
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    isAnimating = true
                }
                withAnimation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: false)
                ) {
                    growthProgress = 1.0
                }
            }
        }
        
        // Helper to calculate position along curve
        private func getPositionAlongPath(progress: CGFloat) -> CGPoint {
            let start = CGPoint(x: size * 0.2, y: size * 0.8)
            let end = CGPoint(x: size * 0.8, y: size * 0.3)
            let control1 = CGPoint(x: size * 0.4, y: size * 0.7)
            let control2 = CGPoint(x: size * 0.7, y: size * 0.5)
            
            return bezierPoint(
                start: start,
                control1: control1,
                control2: control2,
                end: end,
                t: progress
            )
        }
        
        // Calculate point along Bezier curve
        private func bezierPoint(
            start: CGPoint,
            control1: CGPoint,
            control2: CGPoint,
            end: CGPoint,
            t: CGFloat
        ) -> CGPoint {
            let x = cubicBezier(
                start.x,
                control1.x,
                control2.x,
                end.x,
                t: t
            )
            let y = cubicBezier(
                start.y,
                control1.y,
                control2.y,
                end.y,
                t: t
            )
            return CGPoint(x: x, y: y)
        }
        
        // Cubic Bezier formula
        private func cubicBezier(
            _ p0: CGFloat,
            _ p1: CGFloat,
            _ p2: CGFloat,
            _ p3: CGFloat,
            t: CGFloat
        ) -> CGFloat {
            let mt = 1 - t
            return mt * mt * mt * p0 + 3 * mt * mt * t * p1 + 3 * mt * t * t * p2 + t * t * t * p3
        }
    }
    
    // MARK: - Calm Mind Illustration
    struct CalmMind: View {
        var size: CGFloat = 200
        @State private var isAnimating = false
        @State private var pulseScale: CGFloat = 1.0
        
        var body: some View {
            ZStack {
                // Background elements
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            BFColors.oceanBlue.opacity(0.1),
                            lineWidth: size * 0.01
                        )
                        .frame(width: size * (0.6 + CGFloat(i) * 0.2))
                        .scaleEffect(isAnimating ? pulseScale : 1)
                        .animation(
                            Animation.easeInOut(duration: 3)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.5),
                            value: isAnimating
                        )
                }
                
                // Central calm element
                ZStack {
                    // Center circle
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    BFColors.vibrantTeal.opacity(0.8),
                                    BFColors.oceanBlue.opacity(0.5)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size * 0.3, height: size * 0.3)
                        .shadow(color: BFColors.vibrantTeal.opacity(0.3), radius: size * 0.05)
                    
                    // Wave patterns representing calm
                    ForEach(0..<3) { i in
                        Capsule()
                            .trim(from: 0.2, to: 0.8)
                            .stroke(
                                BFColors.vibrantTeal.opacity(0.8 - Double(i) * 0.2),
                                lineWidth: size * 0.01
                            )
                            .frame(width: size * 0.15, height: size * (0.08 + 0.05 * CGFloat(i)))
                            .rotationEffect(.degrees(Double(i) * 60))
                    }
                }
                .scaleEffect(isAnimating ? 1.05 : 1)
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            }
            .frame(width: size, height: size)
            .onAppear {
                isAnimating = true
                pulseScale = 1.2
            }
        }
    }
    
    // MARK: - Support Network Illustration
    struct SupportNetwork: View {
        var size: CGFloat = 200
        @State private var isAnimating = false
        
        var body: some View {
            ZStack {
                // Background grid
                ForEach(0..<3) { row in
                    ForEach(0..<3) { col in
                        if !(row == 1 && col == 1) { // Skip center
                            RoundedRectangle(cornerRadius: size * 0.02)
                                .stroke(
                                    BFColors.deepSpaceBlue.opacity(0.2),
                                    lineWidth: 1
                                )
                                .frame(width: size * 0.15, height: size * 0.15)
                                .offset(
                                    x: CGFloat(col - 1) * size * 0.25,
                                    y: CGFloat(row - 1) * size * 0.25
                                )
                        }
                    }
                }
                
                // Connection lines
                ForEach(0..<8) { i in
                    let angle = Double(i) * .pi / 4
                    let length = size * 0.18
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(
                            x: cos(angle) * length,
                            y: sin(angle) * length
                        ))
                    }
                    .stroke(
                        BFColors.oceanBlue.opacity(isAnimating ? 0.8 : 0.3),
                        lineWidth: size * 0.01
                    )
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.2),
                        value: isAnimating
                    )
                }
                
                // Center element - Strength Circle
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .rotation(.degrees(90))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.vibrantTeal,
                                BFColors.oceanBlue
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.2, height: size * 0.2)
                    .shadow(color: BFColors.vibrantTeal.opacity(0.4), radius: size * 0.03)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                // Surrounding elements - People/nodes
                ForEach(0..<8) { i in
                    let angle = Double(i) * .pi / 4
                    let distance = size * 0.3
                    
                    Circle()
                        .fill(BFColors.vibrantTeal.opacity(0.8))
                        .frame(width: size * 0.08, height: size * 0.08)
                        .offset(
                            x: cos(angle) * distance,
                            y: sin(angle) * distance
                        )
                        .scaleEffect(isAnimating ? 1 + (CGFloat(i % 3) * 0.1) : 1)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.15),
                            value: isAnimating
                        )
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview
struct BFOnboardingIllustrations_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            Text("Onboarding Illustrations")
                .font(.largeTitle)
                .padding(.top)
            
            BFOnboardingIllustrations.BreakingFree(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.GrowthJourney(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.CalmMind(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.SupportNetwork(size: 180)
                .padding()
                .background(BFCard())
        }
        .padding()
        .background(BFColors.adaptiveBackground(for: .light))
        .previewDisplayName("Light Mode")
        
        VStack(spacing: 30) {
            Text("Onboarding Illustrations")
                .font(.largeTitle)
                .padding(.top)
            
            BFOnboardingIllustrations.BreakingFree(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.GrowthJourney(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.CalmMind(size: 180)
                .padding()
                .background(BFCard())
            
            BFOnboardingIllustrations.SupportNetwork(size: 180)
                .padding()
                .background(BFCard())
        }
        .padding()
        .background(BFColors.deepSpaceBlue)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
} 