import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        ZStack {
            // Adaptive background - sophisticated light mode, original dark mode
            ZStack {
                // Base gradient that adapts to color scheme
                LinearGradient(
                    colors: [
                        Color.gradientTop,
                        Color.gradientMiddle, 
                        Color.gradientBottom
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Light mode overlay for subtle white-blue effect
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.8),
                        Color.focusBlue.opacity(0.05),
                        Color.focusBlue.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.overlay)
                .opacity(colorScheme == .light ? 1.0 : 0.0)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        onComplete()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(colorScheme == .light ? .focusBlue : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .light ? Color.white.opacity(0.8) : Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .light ? Color.focusBlue.opacity(0.3) : Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                
                Spacer()
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page, isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: 500)
                
                Spacer()
                
                // Bottom section
                VStack(spacing: 24) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? 
                                      (colorScheme == .light ? Color.focusBlue : Color.white) : 
                                      (colorScheme == .light ? Color.focusBlue.opacity(0.3) : Color.white.opacity(0.3)))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button(action: previousPage) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(colorScheme == .light ? .focusBlue : .white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(colorScheme == .light ? Color.white.opacity(0.8) : Color.white.opacity(0.25))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(colorScheme == .light ? Color.focusBlue.opacity(0.3) : Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .shadow(color: colorScheme == .light ? .focusBlue.opacity(0.2) : .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                        } else {
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button(action: nextPage) {
                            HStack {
                                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.focusBlue)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            )
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: currentPage) { _, _ in
            // Trigger animation for the new page
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
    }
    
    private func previousPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentPage = max(0, currentPage - 1)
        }
    }
    
    private func nextPage() {
        if currentPage == pages.count - 1 {
            onComplete()
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPage = min(pages.count - 1, currentPage + 1)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 40) {
            // Icon
            ZStack {
                Circle()
                    .fill(colorScheme == .light ? Color.white.opacity(0.8) : Color.white.opacity(0.15))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .stroke(colorScheme == .light ? Color.focusBlue.opacity(0.3) : Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: colorScheme == .light ? .focusBlue.opacity(0.2) : .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)
                
                if page.useAppIcon {
                    // Use actual app icon for the first page
                    Image("app_icon_display")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(colorScheme == .light ? Color.focusBlue.opacity(0.3) : Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: colorScheme == .light ? .focusBlue.opacity(0.3) : .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                } else {
                    Image(systemName: page.icon)
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(colorScheme == .light ? .focusBlue : .white)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                }
            }
            
            // Content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .light ? .focusBlue : .white)
                    .multilineTextAlignment(.center)
                    .shadow(color: colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isAnimating)
                
                Text(page.description)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(colorScheme == .light ? .focusBlue.opacity(0.8) : .white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
                    .shadow(color: colorScheme == .light ? .white.opacity(0.5) : .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isAnimating)
                
                if !page.features.isEmpty {
                    VStack(spacing: 12) {
                        ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 18, weight: .semibold))
                                    .shadow(color: colorScheme == .light ? .white.opacity(0.3) : .black.opacity(0.2), radius: 1, x: 0, y: 1)
                                
                                Text(feature)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(colorScheme == .light ? .focusBlue.opacity(0.7) : .white.opacity(0.9))
                                    .shadow(color: colorScheme == .light ? .white.opacity(0.3) : .black.opacity(0.2), radius: 1, x: 0, y: 1)
                                
                                Spacer()
                            }
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .offset(x: isAnimating ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5 + Double(index) * 0.1), value: isAnimating)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let useAppIcon: Bool
    
    static let allPages = [
        OnboardingPage(
            icon: "magnifyingglass.circle.fill",
            title: "Welcome to SkipFeed",
            description: "Skip the endless scrolling and find exactly what you're looking for across all your favorite platforms.",
            features: [
                "Search YouTube, Reddit, TikTok, and more",
                "Skip distracting feeds and recommendations",
                "Direct access to relevant content"
            ],
            useAppIcon: true
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Track Your Productivity",
            description: "Monitor how much time you save by using direct search instead of endless scrolling.",
            features: [
                "See time saved vs endless scrolling",
                "Track usage patterns across platforms",
                "Analyze your most productive search times"
            ],
            useAppIcon: false
        ),
        OnboardingPage(
            icon: "clock.arrow.circlepath",
            title: "Search History & Insights",
            description: "Keep track of your searches and export your data whenever you need it.",
            features: [
                "Complete search history with timestamps",
                "Export your data in CSV or TXT format",
                "Filter and search through past queries"
            ],
            useAppIcon: false
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "Privacy First", 
            description: "All your data stays on your device. We don't track, collect, or share your search activity.",
            features: [
                "100% local data storage",
                "No tracking or analytics", 
                "You control your data retention"
            ],
            useAppIcon: false
        )
    ]
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
