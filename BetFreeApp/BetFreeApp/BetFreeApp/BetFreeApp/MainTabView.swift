import SwiftUI

// Helper function to get safe area bottom inset using modern API
fileprivate func getSafeAreaBottom() -> CGFloat {
    if #available(iOS 15.0, *) {
        // Use the new UIWindowScene.windows API on iOS 15+
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
    } else {
        // Fallback for older iOS versions
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

// Define the tab types
enum BFTab {
    case home
    case goals
    case stats
    case profile
}

/**
 * MainTabView
 * The main tab interface after onboarding, featuring a mindfulness-focused approach
 */

struct MainTabView: View {
    @EnvironmentObject private var appState: EnhancedAppState
    @EnvironmentObject private var bfAppState: BFAppState
    @State private var selectedTab = 0
    @State private var showMindfulnessSheet = false
    @State private var quickStartExercise: (name: String, duration: Int, category: String)? = nil
    
    // Make sure to hide the default tab bar appearance using multiple approaches
    init() {
        // Primary approach - hide it completely
        UITabBar.appearance().isHidden = true
        
        // Backup approach - make it transparent if it somehow becomes visible
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    // Quick start mindfulness options
    let quickStartOptions = [
        (name: "Deep Breathing", duration: 5, category: "Breathing"),
        (name: "Body Scan", duration: 10, category: "Body Awareness"),
        (name: "Loving Kindness", duration: 7, category: "Compassion"),
        (name: "Urge Surfing", duration: 8, category: "Urge Management")
    ]
    
    // Computed properties for dynamic sizing
    private var fontScale: CGFloat {
        let width = UIScreen.main.bounds.width
        if width > 400 {
            return 1.0
        } else if width > 350 {
            return 0.9
        } else {
            return 0.8
        }
    }
    
    // Use a custom view container instead of TabView to avoid default iOS tab bar
    @ViewBuilder
    private func currentView() -> some View {
        switch selectedTab {
        case 0:
            MainCounterView()
                .edgesIgnoringSafeArea(.all)
        case 1:
                NavigationView {
                ProgressTrackingView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            EmptyView()
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        // Add safe space for the tab bar and floating button
                        Spacer().frame(height: 90)
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case 3:
                NavigationView {
                    JournalView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            EmptyView()
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        // Add safe space for the tab bar and floating button
                        Spacer().frame(height: 90)
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case 4:
            NavigationView {
                ProfileView()
                    .environmentObject(appState)
                    .edgesIgnoringSafeArea(.bottom) // Ensure ProfileView has full screen height
                    .padding(.bottom, 80) // Extra padding to ensure content doesn't hide behind the tab bar
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            EmptyView()
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        // Add safe space for the tab bar and floating button
                        Spacer().frame(height: 90)
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        // Use a ZStack instead of TabView to completely avoid the default iOS tab bar
        ZStack(alignment: .bottom) {
            // Dark background for entire view
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)), // #10172A
                    Color(UIColor(red: 0.11, green: 0.17, blue: 0.29, alpha: 1.0))  // #1c2b4b
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content area
            currentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard) // Prevent keyboard from pushing content
            
            // Bottom navigation elements
            VStack(spacing: 0) {
                Spacer()
                
                // Tab bar
                if appState.isTabBarVisible {
                    customTabBar
                        .zIndex(100) // Ensure it stays on top of any other UI elements
                        .transition(.move(edge: .bottom))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: appState.isTabBarVisible)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Quick start button - floating action button
            floatingActionButton
                .offset(y: appState.isTabBarVisible ? -30 : 30)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: appState.isTabBarVisible)
        }
        .onAppear {
            configureNavigationBarAppearance()
        }
        .sheet(isPresented: $showMindfulnessSheet, onDismiss: {
            // When sheet is dismissed but an exercise was selected
            if let exercise = quickStartExercise {
                // Record the session
                let newSession = EnhancedMindfulnessSession(
                    date: Date(),
                    duration: exercise.duration,
                    type: exercise.name
                )
                appState.saveMindfulnessSession(newSession)
                quickStartExercise = nil
            }
        }) {
            if let exercise = quickStartExercise {
                // If specific exercise is selected, show the session view
                MindfulnessSessionView(
                    exerciseName: exercise.name,
                    duration: exercise.duration,
                    category: exercise.category,
                    isPresented: .constant(true)
                )
            } else {
                // Otherwise show quick start menu
                quickStartMenuView
            }
        }
        .accentColor(Color(UIColor(red: 0.39, green: 1.0, blue: 0.85, alpha: 1.0)))
    }
    
    // MARK: - Tab Content Views
    
    private func tabContentFor(_ tab: BFTab) -> some View {
        Group {
            switch tab {
            case .home:
                DashboardView()
                    .environmentObject(appState)
            case .goals:
                GoalsView()
                    .environmentObject(appState)
            case .stats:
                EnhancedStatsView()
                    .environmentObject(appState)
                    .edgesIgnoringSafeArea(.bottom) // Add this to ensure scroll view uses full space
            case .profile:
                ProfileView()
                    .environmentObject(appState)
                    .edgesIgnoringSafeArea(.bottom) // Ensure ProfileView has full screen height
                    .padding(.bottom, 80) // Extra padding to ensure content doesn't hide behind the tab bar
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure each tab view uses full space
    }
    
    // Custom tab bar view
    private var customTabBar: some View {
        HStack(alignment: .center) {
            ForEach(0..<5) { index in
                // Skip center item (special handling for FAB)
                if index != 2 {
                    Spacer()
                    
                    Button(action: {
                        if index != selectedTab {
                            // Add haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            // Animate tab change
                            withAnimation {
                                selectedTab = index
                            }
                        }
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: getTabIcon(for: index))
                                .font(.system(size: index == selectedTab ? 28 : 24, weight: .bold))
                                .foregroundColor(index == selectedTab ? 
                                    BFDesignTokens.Colors.tabBarSelected : 
                                    Color.white.opacity(0.85))
                                .scaleEffect(index == selectedTab ? 1.2 : 1.0)
                                .shadow(color: index == selectedTab ? BFDesignTokens.Colors.tabBarSelected.opacity(0.7) : Color.clear, radius: 5, x: 0, y: 0)
                                .shadow(color: index == selectedTab ? BFDesignTokens.Colors.tabBarSelected.opacity(0.5) : Color.clear, radius: 10, x: 0, y: 0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                            
                            Text(getTabTitle(for: index))
                                .font(.system(size: 12 * fontScale, weight: index == selectedTab ? .bold : .medium, design: .rounded))
                                .foregroundColor(index == selectedTab ? 
                                    BFDesignTokens.Colors.tabBarSelected : 
                                    Color.white.opacity(0.85))
                                .opacity(index == selectedTab ? 1.0 : 0.9)
                                .lineLimit(1)
                                .fixedSize()
                        }
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .overlay(
                            // Add indicator line under selected tab
                            Rectangle()
                                .fill(BFDesignTokens.Colors.tabBarSelected.opacity(index == selectedTab ? 0.8 : 0.0))
                                .frame(height: 3, alignment: .top)
                                .offset(y: -5)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                            , alignment: .top
                        )
                    }
                    .buttonStyle(TabButtonStyle())
                    
                    Spacer()
                } else {
                    // Center space for the floating action button
                    Spacer()
                        .frame(width: 70)
                }
            }
        }
        .padding(.top, 6)
        .padding(.bottom, 5 + (getSafeAreaBottom()))
        .frame(height: 65 + (getSafeAreaBottom()))
        .background(
            // Enhanced tab bar background with more prominent styling
            ZStack {
                // Darker background for tab bar with better contrast
                BFDesignTokens.Colors.tabBarBackground
                    .background(Material.ultraThinMaterial)
                
                // Top line with more visible gradient
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            BFDesignTokens.Colors.tabBarSelected.opacity(0.5),
                            BFDesignTokens.Colors.tabBarSelected.opacity(0.3)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 2)
                    .shadow(color: BFDesignTokens.Colors.tabBarSelected.opacity(0.4), radius: 4, y: 1)
                    Spacer()
                }
            }
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -2)
    }
    
    // Floating action button for quick actions
    private var floatingActionButton: some View {
        Button(action: {
            showMindfulnessSheet = true
            
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }) {
            ZStack {
                // Outer glow
                Circle()
                    .fill(Color(UIColor(red: 0.39, green: 1.0, blue: 0.85, alpha: 0.2)))
                    .frame(width: 72, height: 72)
                    .shadow(color: Color(UIColor(red: 0.39, green: 1.0, blue: 0.85, alpha: 0.4)), radius: 10, x: 0, y: 4)
                
                // Main button
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor(red: 0.11, green: 0.82, blue: 0.85, alpha: 1.0)),  // Cyan
                                Color(UIColor(red: 0.40, green: 0.98, blue: 0.88, alpha: 1.0))   // Teal
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 62, height: 62)
                    .shadow(color: Color(UIColor(red: 0.0, green: 0.71, blue: 0.85, alpha: 0.4)), radius: 5, x: 0, y: 3)
                
                // Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .rotationEffect(Angle(degrees: showMindfulnessSheet ? 45 : 0))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showMindfulnessSheet)
            }
        }
        .buttonStyle(SpringButtonStyle())
        .offset(y: -25) // Raise further above the tab bar
        .scaleEffect(showMindfulnessSheet ? 0.9 : 1.0) // Add subtle press animation
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showMindfulnessSheet)
    }
    
    // Helper method to get tab icons - using very bold, distinct icons for better visibility
    private func getTabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.circle.fill"
        case 1: return "chart.pie.fill"
        case 3: return "book.closed.circle.fill"
        case 4: return "person.crop.circle.fill"
        default: return ""
        }
    }
    
    // Helper method to get tab titles
    private func getTabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Progress"
        case 3: return "Journal"
        case 4: return "Profile"
        default: return ""
        }
    }
    
    // Configure the appearance of navigation bars globally
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // For better blending with our dark theme
        appearance.backgroundColor = UIColor(Color(hex: "#10172A").opacity(0.2))
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        // Style the title text
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        // Style the large title text
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        
        // Apply to all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // =================
        // Tab Bar Appearance - Multiple approaches to ensure it's completely hidden/styled
        // =================
        
        // 1. Completely hide the tab bar
        UITabBar.appearance().isHidden = true
        
        // 2. Make it transparent as a fallback
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = nil
        tabBarAppearance.backgroundColor = UIColor.clear
        tabBarAppearance.shadowColor = .clear
        tabBarAppearance.shadowImage = nil
        
        // 3. For iOS 15+ fix the scroll edge appearance too
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        // 4. Attempt to find and hide any existing tab bars in the view hierarchy
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    if let rootVC = window.rootViewController {
                        self.hideTabBars(in: rootVC)
                    }
                }
            }
        }
    }
    
    // Helper method to recursively find and hide all tab bars
    private func hideTabBars(in viewController: UIViewController) {
        if let tabBarController = viewController as? UITabBarController {
            tabBarController.tabBar.isHidden = true
        }
        
        for child in viewController.children {
            hideTabBars(in: child)
        }
        
        if let presented = viewController.presentedViewController {
            hideTabBars(in: presented)
        }
    }
    
    // Button style for the tab bar buttons
    struct TabButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .opacity(configuration.isPressed ? 0.7 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }
    
    // Button style for the floating action button with spring animation
    struct SpringButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
        }
    }
    
    // Quick start menu for selecting a mindfulness session
    private var quickStartMenuView: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 10) {
                    Text("Quick Mindfulness")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BFColorSystem.textPrimary)
                    
                    Text("Choose a quick mindfulness exercise")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(BFColorSystem.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 30)
                
                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)
                
                // Session options
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(quickStartOptions, id: \.name) { option in
                            Button(action: {
                                quickStartExercise = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.name)
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            .foregroundColor(BFColorSystem.textPrimary)
                                        
                                        Text("\(option.duration) min • \(option.category)")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(BFColorSystem.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(UIColor(red: 0.31, green: 0.46, blue: 0.97, alpha: 1.0)))
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                            }
                            
                            // Divider after each item except the last
                            if option.name != quickStartOptions.last?.name {
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                
                // Custom duration option
                Button(action: {
                    // For now just use a default custom session
                    quickStartExercise = (name: "Custom Session", duration: 10, category: "Mindfulness")
                }) {
                    HStack {
                        Image(systemName: "timer")
                            .font(.system(size: 18))
                            .foregroundColor(Color(UIColor(red: 0.31, green: 0.46, blue: 0.97, alpha: 1.0)))
                        
                        Text("Custom Duration")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(UIColor(red: 0.31, green: 0.46, blue: 0.97, alpha: 1.0)))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                
                // Cancel button
                Button(action: {
                    showMindfulnessSheet = false
                }) {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(BFColorSystem.textSecondary)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 20)
            }
            .background(BFColorSystem.cardBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Placeholder Views
// These will be replaced with actual implementations in future sprints

struct ProgressView: View {
    // Demo state for visual indicators
    @State private var weeklyTrend: Bool = true  // true = positive trend
    @State private var streakGoal: Int = 10
    @State private var activeDays: [Bool] = [true, false, false, false, false, true, true] // M,T,W,T,F,S,S
    
    // Computed dynamic sizing properties
    private var fontScale: CGFloat {
        // Base scale on device width
        let width = UIScreen.main.bounds.width
        if width > 400 {  // Larger devices
            return 1.0
        } else if width > 350 {  // Medium devices
            return 0.9
        } else {  // Small devices
            return 0.8
        }
    }
    
    private var numberFontSize: CGFloat { 55 * fontScale }
    private var labelFontSize: CGFloat { 16 * fontScale }
    private var iconSize: CGFloat { 14 * fontScale }
    private var standardPadding: CGFloat { 16 * fontScale }
    private var dayCircleSize: CGFloat { 40 * fontScale }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let cardWidth = (width - 45) / 2  // 15 padding on sides + 15 between cards
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15 * fontScale) {
                    // Top row - Completion and Streak
                    HStack(spacing: 15) {
                        // Weekly Completion Card
                        VStack(alignment: .leading, spacing: 6 * fontScale) {
                            HStack(alignment: .center, spacing: 4) {
                                Text("72%")
                                    .font(.system(size: numberFontSize, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#4E76F7"))
                                    .minimumScaleFactor(0.6)
                                    .lineLimit(1)
                                    
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: numberFontSize * 0.43))
                                    .foregroundColor(Color(hex: "#00f5d4"))
                                    .padding(.leading, -4)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: iconSize))
                                    .foregroundColor(Color(hex: "#00f5d4"))
                                    
                                Text("Weekly completion")
                                    .font(.system(size: labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                        }
                        .padding(standardPadding)
                        .frame(width: cardWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#2D3142").opacity(0.3))
                        )
                        
                        // Streak Card
                        VStack(alignment: .leading, spacing: 6 * fontScale) {
                            Text("6")
                                .font(.system(size: numberFontSize, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#4E76F7"))
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: iconSize))
                                    .foregroundColor(Color(hex: "#FF6B6B"))
                                
                                Text("Day streak")
                                    .font(.system(size: labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                            
                            // Simple streak indicator
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 5 * fontScale)
                                
                                // Progress bar
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "#FF5252"), Color(hex: "#FF9A8B")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: (cardWidth - standardPadding * 2) * (6 / CGFloat(streakGoal)), height: 5 * fontScale)
                            }
                            .padding(.top, 4 * fontScale)
                        }
                        .padding(standardPadding)
                        .frame(width: cardWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#2D3142").opacity(0.3))
                        )
                    }
                    .padding(.horizontal, 15)
                    
                    // Bottom row - Time and Sessions
                    HStack(spacing: 15) {
                        // Mindful Minutes Card
                        VStack(alignment: .leading, spacing: 6 * fontScale) {
                            Text("125")
                                .font(.system(size: numberFontSize, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#4E76F7"))
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: iconSize))
                                    .foregroundColor(Color(hex: "#00f5d4"))
                                
                                Text("Mindful minutes")
                                    .font(.system(size: labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                        }
                        .padding(standardPadding)
                        .frame(width: cardWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#2D3142").opacity(0.3))
                        )
                        
                        // Weekly Sessions Card
                        VStack(alignment: .leading, spacing: 6 * fontScale) {
                            Text("8")
                                .font(.system(size: numberFontSize, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#4E76F7"))
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "figure.mind.and.body")
                                    .font(.system(size: iconSize))
                                    .foregroundColor(Color(hex: "#00f5d4"))
                                
                                Text("Weekly sessions")
                                    .font(.system(size: labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                        }
                        .padding(standardPadding)
                        .frame(width: cardWidth, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#2D3142").opacity(0.3))
                        )
                    }
                    .padding(.horizontal, 15)
                    
                    // Week overview
                    VStack(alignment: .leading, spacing: 16 * fontScale) {
                        Text("This Week")
                            .font(.system(size: 18 * fontScale, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                        
                        // Session days of week indicator
                        let days = ["M", "T", "W", "T", "F", "S", "S"]
                        HStack(spacing: min(10, (width - 30 - dayCircleSize * 7) / 6)) {
                            ForEach(0..<days.count, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(activeDays[index] ? Color(hex: "#4E76F7").opacity(0.7) : Color.white.opacity(0.12))
                                        .frame(width: dayCircleSize, height: dayCircleSize)
                                    
                                    Text(days[index])
                                        .font(.system(size: labelFontSize, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                    }
                    .padding(.vertical, standardPadding)
                    .padding(.horizontal, standardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "#2D3142").opacity(0.3))
                    )
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    
                    // Insights section to fill the empty space
                    VStack(alignment: .leading, spacing: 16 * fontScale) {
                        HStack {
                            Text("Insights")
                                .font(.system(size: 18 * fontScale, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                Spacer()
                            
                            Text("Last 30 days")
                                .font(.system(size: 14 * fontScale, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.bottom, 5 * fontScale)
                        
                        // Simple bar chart
                        HStack(alignment: .bottom, spacing: 6 * fontScale) {
                            ForEach(0..<7) { index in
                                let height = [0.4, 0.6, 0.3, 0.5, 0.7, 0.9, 0.6][index]
                                
                                VStack(spacing: 6 * fontScale) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#4E76F7").opacity(0.7 + 0.3 * height))
                                        .frame(height: 100 * height * fontScale)
                                    
                                    Text(["W1", "W2", "W3", "W4", "W5", "W6", "W7"][index])
                                        .font(.system(size: 12 * fontScale, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .padding(.vertical, 10 * fontScale)
                        
                        // Insights text
                        VStack(spacing: 12 * fontScale) {
                            insightRow(icon: "arrow.up.right", text: "Your consistency has improved by 15% this week", color: "#00f5d4")
                            
                            insightRow(icon: "star.fill", text: "You've reached a new personal record of 6 day streak", color: "#FF6B6B")
                            
                            insightRow(icon: "chart.bar.fill", text: "Try to complete 2 more sessions to reach your weekly goal", color: "#4E76F7")
                        }
                    }
                    .padding(.vertical, standardPadding)
                    .padding(.horizontal, standardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "#2D3142").opacity(0.3))
                    )
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                }
                .padding(.top, 15)
                .padding(.bottom, 15)
            }
        }
        // Use the same dark blue gradient as onboarding and profile
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#10172A"), Color(hex: "#1c2b4b")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Progress")
    }
    
    // Helper to create insight row
    private func insightRow(icon: String, text: String, color: String) -> some View {
        HStack(spacing: 12 * fontScale) {
            ZStack {
                Circle()
                    .fill(Color(hex: color).opacity(0.2))
                    .frame(width: 34 * fontScale, height: 34 * fontScale)
                
                Image(systemName: icon)
                    .font(.system(size: 14 * fontScale))
                    .foregroundColor(Color(hex: color))
            }
            
            Text(text)
                .font(.system(size: 14 * fontScale, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct JournalView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Placeholder content
                Text("Mindfulness Journal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(BFColorSystem.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Text("Record your thoughts and feelings")
                    .font(.title3)
                    .foregroundColor(BFColorSystem.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Add new entry button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        
                        Text("Add New Journal Entry")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#4E76F7"), Color(hex: "#3D63D2")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // Empty state
                VStack(spacing: 20) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 60))
                        .foregroundColor(BFColorSystem.textSecondary.opacity(0.5))
                        .padding(.top, 60)
                    
                    Text("No journal entries yet")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(BFColorSystem.textSecondary)
                    
                    Text("Start recording your mindfulness journey")
                        .font(.subheadline)
                        .foregroundColor(BFColorSystem.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                
                Spacer()
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#10172A"), Color(hex: "#1c2b4b")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Journal")
    }
}

// MARK: - Preview Provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(EnhancedAppState())
            .environmentObject(BFAppState())
            .preferredColorScheme(.dark)
    }
}