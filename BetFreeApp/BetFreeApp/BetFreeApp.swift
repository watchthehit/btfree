import SwiftUI

@main
struct BetFreeApp: App {
    // Register app delegate for lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Use AppStorage to persist the state across app restarts during development
    @AppStorage("hasShownSplash") private var hasShownSplash = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true
    @State private var forceShowMainContent = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if forceShowMainContent {
                    // Force show main content
                    NavigationView {
                        MainTabView()
                    }
                    .accentColor(BFColors.vibrantTeal)
                } else if !hasShownSplash {
                    // Show splash screen on launch
                    SplashScreen()
                        .onAppear {
                            print("Splash screen appeared")
                            // After 2.5 seconds, dismiss splash screen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                print("Transitioning from splash screen")
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    hasShownSplash = true
                                }
                            }
                        }
                        .zIndex(1) // Ensure splash is on top
                } else if !hasCompletedOnboarding {
                    // Show onboarding for new users
                    NewOnboardingView(onCompleteOnboarding: {
                        // This closure will be called when onboarding completes
                        print("MAIN APP: Onboarding completed via closure")
                        
                        // Multiple approaches to ensure completion works
                        hasCompletedOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        UserDefaults.standard.synchronize()
                        
                        // Force show main content as fallback
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print("MAIN APP: Forcing main content display")
                            withAnimation {
                                forceShowMainContent = true
                            }
                        }
                    })
                    .onDisappear {
                        // Backup method - if view disappears, complete onboarding
                        print("MAIN APP: Onboarding view disappeared")
                        hasCompletedOnboarding = true
                    }
                } else {
                    // Main content navigation
                    NavigationView {
                        MainTabView()
                    }
                    .accentColor(BFColors.vibrantTeal) // Use Serene Strength teal as accent color
                    .onAppear {
                        print("MAIN APP: Main content appeared")
                    }
                    .zIndex(0) // Behind splash during transition
                }
            }
            .onChange(of: hasCompletedOnboarding) { newValue in
                // Log when the onboarding state changes
                print("MAIN APP: hasCompletedOnboarding changed to \(newValue)")
            }
        }
    }
}

// Main app navigation with tabs
struct MainTabView: View {
    @State private var showDesignSystem = false
    
    var body: some View {
        TabView {
            // Dashboard Tab (Home)
            VStack {
                Text("Dashboard Screen")
                    .font(.title)
                    .padding(.bottom, 30)
                
                BFButton(
                    title: "View Design System",
                    style: .primary,
                    icon: "paintpalette.fill",
                    action: {
                        showDesignSystem = true
                    },
                    isFullWidth: true
                )
                .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showDesignSystem) {
                NavigationView {
                    DesignSystemView()
                        .navigationBarItems(trailing: Button("Done") {
                            showDesignSystem = false
                        })
                }
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            
            // Report Tab
            Text("Report Screen") 
                .tabItem {
                    Label("Report", systemImage: "chart.bar.fill")
                }
            
            // Settings Tab
            VStack {
                Text("Settings")
                    .font(.title)
                    .padding(.bottom, 30)
                
                // Developer section
                VStack(alignment: .leading) {
                    Text("Developer Options")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    BFButton(
                        title: "Reset Onboarding",
                        style: .secondary,
                        icon: "arrow.clockwise.circle",
                        action: {
                            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                        },
                        isFullWidth: true
                    )
                    .padding(.bottom, 8)
                    
                    BFButton(
                        title: "Reset Splash Screen",
                        style: .secondary,
                        icon: "arrow.clockwise.circle",
                        action: {
                            UserDefaults.standard.set(false, forKey: "hasShownSplash")
                        },
                        isFullWidth: true
                    )
                    .padding(.bottom, 8)
                    
                    Text("After resetting, fully restart the app to see changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal, 20)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .accentColor(BFColors.vibrantTeal) // Use Serene Strength teal as accent color
    }
}

// Combined design system view with logo and components
struct DesignSystemView: View {
    @State private var selectedSection = 0
    private let sections = ["Logo & Brand", "Components", "Illustrations", "Colors"]
    
    var body: some View {
        VStack {
            // Section picker
            Picker("Design Section", selection: $selectedSection) {
                ForEach(0..<sections.count, id: \.self) { index in
                    Text(sections[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Display selected section
            ScrollView {
                VStack {
                    switch selectedSection {
                    case 0:
                        LogoDemo()
                    case 1:
                        ComponentLibraryContent()
                    case 2:
                        IllustrationsView()
                    case 3:
                        ColorsView()
                    default:
                        EmptyView()
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Design System")
        .background(BFColors.adaptiveBackground(for: colorScheme))
    }
    
    @Environment(\.colorScheme) private var colorScheme
}

// Component library content view
struct ComponentLibraryContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Buttons
            GroupBox(label: Text("Buttons").font(.headline)) {
                VStack(spacing: 20) {
                    BFButton(
                        title: "Primary Button",
                        style: .primary,
                        action: {}
                    )
                    
                    BFButton(
                        title: "Secondary Button",
                        style: .secondary,
                        action: {}
                    )
                    
                    BFButton(
                        title: "Text Button",
                        style: .text,
                        action: {}
                    )
                }
                .padding()
            }
            .padding(.horizontal)
            
            // Cards
            GroupBox(label: Text("Cards").font(.headline)) {
                VStack(spacing: 20) {
                    BFCard {
                        Text("Standard Card")
                            .padding()
                    }
                    
                    BFCard(style: .elevated) {
                        Text("Elevated Card")
                            .padding()
                    }
                    
                    BFCard(style: .outlined) {
                        Text("Outlined Card")
                            .padding()
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

// Illustrations view
struct IllustrationsView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Illustrations
            GroupBox(label: Text("Onboarding Illustrations").font(.headline)) {
                VStack(spacing: 20) {
                    BFOnboardingIllustrations.BreakingFree(size: 150)
                        .padding()
                    
                    Divider()
                    
                    BFOnboardingIllustrations.GrowthJourney(size: 150)
                        .padding()
                    
                    Divider()
                    
                    BFOnboardingIllustrations.CalmMind(size: 150)
                        .padding()
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

// Colors view
struct ColorsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GroupBox(label: Text("Primary Colors").font(.headline)) {
                VStack(spacing: 12) {
                    colorSwatch("Deep Space Blue", color: BFColors.deepSpaceBlue)
                    colorSwatch("Oxford Blue", color: BFColors.oxfordBlue)
                    colorSwatch("Vibrant Teal", color: BFColors.vibrantTeal)
                    colorSwatch("Ocean Blue", color: BFColors.oceanBlue)
                    colorSwatch("Coral", color: BFColors.coral)
                }
                .padding()
            }
            .padding(.horizontal)
            
            GroupBox(label: Text("Gradients").font(.headline)) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Brand Gradient")
                            .font(.subheadline)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(BFColors.brandGradient())
                            .frame(height: 50)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Dark Gradient")
                            .font(.subheadline)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(BFColors.darkGradient())
                            .frame(height: 50)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func colorSwatch(_ name: String, color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 60, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

// MARK: - Preview
struct BetFreeApp_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 