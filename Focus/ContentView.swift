import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedPlatform: Platform = .youtube
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showingSettings = false
    @State private var showingData = false
    @State private var showingPremiumUpgrade = false

    @StateObject private var searchService = SearchService.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var doNotDisturbManager = DoNotDisturbManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            // Dark mode-aware glassmorphism background
            LinearGradient(
                colors: [
                    Color.gradientTop,
                    Color.gradientMiddle,
                    Color.gradientBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .onTapGesture {
                // Dismiss keyboard when tapping background
                hideKeyboard()
            }
            
            VStack(spacing: 28) {
                // Header with navigation
                HStack {
                    Button(action: { showingData = true }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title3)
                            .foregroundColor(.focusBlue)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Text("SkipFeed")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color.focusBlue)

                        Text("Skip the feed, find what matters")
                            .font(.caption)
                            .foregroundColor(Color.secondaryText)
                            .fontWeight(.medium)
                    }

                    Spacer()

                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.focusBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Platform selector with dynamic ordering
                PlatformSelectorView(
                    selectedPlatform: $selectedPlatform,
                    platforms: userPreferences.getOrderedPlatforms()
                )
                .padding(.top, 2)
                
                // Search section
                VStack(spacing: 18) {
                    // Only show search input for non-TikTok platforms
                    if selectedPlatform != .tiktok {
                        // Search input with glass style
                        SearchInputView(
                            searchText: $searchText,
                            platform: selectedPlatform,
                            onSearch: performSearch
                        )

                        // Search mode toggle under search bar with reduced spacing
                        SearchModeToggleView()
                            .padding(.top, -6)
                    } else {
                        // For TikTok, show a simple message
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.focusBlue)
                                .font(.caption2)
                            Text("Opens TikTok search page where you can input your query")
                                .font(.caption2)
                                .foregroundColor(Color.secondaryText)
                            Spacer()
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    // Glass style search button - restored original
                    Button(action: performSearch) {
                        HStack(spacing: 12) {
                            if isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.focusBlue))
                                    .scaleEffect(0.8)
                            } else {
                            Image(systemName: "magnifyingglass")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            Text(isSearching ? "Searching..." : getSimpleSearchButtonText())
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(
                                colors: [Color.focusBlue, Color.backgroundPrimary.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.selectedShadowColor, radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassStroke, lineWidth: 1)
                        )
                    }
                    .disabled((searchText.isEmpty && selectedPlatform != .tiktok) || isSearching)
                    .scaleEffect(isSearching ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearching)
                }
                .padding(.horizontal, 30)
                
                // Recent searches section - restored original
                if !searchService.recentSearches.isEmpty && searchText.isEmpty && selectedPlatform != .tiktok {
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Color.focusBlue)
                                .font(.caption)
                            
                            Text(localizationManager.localizedString(.recentSearches))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color.secondaryText)

                            Spacer()

                            Button(localizationManager.localizedString(.clear)) {
                                searchService.recentSearches.removeAll()
                            }
                            .font(.caption2)
                            .foregroundColor(Color.secondaryText)
                        }
                        .padding(.horizontal, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(searchService.recentSearches.prefix(5), id: \.self) { recentSearch in
                                    Button(action: {
                                        // Dismiss keyboard first
                                        hideKeyboard()
                                        searchText = recentSearch
                                        performSearch()
                                    }) {
                                        Text(recentSearch)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(Color.focusBlue)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.glassStroke, lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Footer with app info
                VStack(spacing: 8) {
                    Text("Skip the feed, find what matters")
                        .font(.caption)
                        .foregroundColor(Color.focusBlue.opacity(0.7))

                    Text("Direct search, zero distractions")
                        .font(.caption2)
                        .foregroundColor(Color.tertiaryText)
                }
                .padding(.bottom, 30)
            }
            
            // Removed SearchResultsView overlay - free tier uses direct navigation only
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
        .sheet(isPresented: $showingData) {
            DataView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumUpgradeView()
        }

        .onAppear {
            // Start trial if user hasn't started it yet
            if !premiumManager.isPremiumUser && !premiumManager.isTrialActive {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Show trial offer after a delay
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    private func getSimpleSearchButtonText() -> String {
        // Special handling for TikTok - users input query in WebView
        if selectedPlatform == .tiktok {
            return localizationManager.localizedString(.openTikTokSearch)
        }

        // Check if native app is available for other platforms
        if URLSchemeHandler.shared.canOpenNativeApp(platform: selectedPlatform) {
            return "\(localizationManager.localizedString(.openIn)) \(selectedPlatform.displayName) App"
        } else {
            return "\(localizationManager.localizedString(.searchOn)) \(selectedPlatform.displayName)"
        }
    }
    
    private func performSearch() {
        // Enable Do Not Disturb if preference is set
        if premiumManager.isPremiumFeatureAvailable(.doNotDisturb) && userPreferences.isDoNotDisturbEnabled() {
            doNotDisturbManager.enableDoNotDisturb()
        }

        // Special handling for TikTok - no search text required
        if selectedPlatform == .tiktok {
            hideKeyboard()
            isSearching = true

            // Record analytics
            analyticsManager.recordSearch(for: selectedPlatform)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let success = searchService.directSearch(query: "", platform: selectedPlatform)
                self.isSearching = false

                if !success {
                    print("Failed to open \(selectedPlatform.displayName)")
                }
            }
            return
        }

        // For other platforms, require search text
        guard !searchText.isEmpty else { return }

        // Dismiss keyboard when performing search
        hideKeyboard()

        // Record analytics and search history
        analyticsManager.recordSearch(for: selectedPlatform)

        if premiumManager.isPremiumFeatureAvailable(.searchHistory) {
            SearchHistoryManager.shared.addSearchToHistory(
                query: searchText,
                platform: selectedPlatform
            )
        }

        isSearching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let searchMode = userPreferences.getSearchMode()
            let success: Bool

            switch searchMode {
            case .direct:
                success = searchService.directSearch(query: searchText, platform: selectedPlatform)
            case .inApp:
                // For in-app browsing, we would show results in a web view
                // For now, fall back to direct search
                success = searchService.directSearch(query: searchText, platform: selectedPlatform)
            }

            self.isSearching = false

            if !success {
                print("Failed to open \(selectedPlatform.displayName)")
            }
        }
    }
}

// Premium upgrade views removed for free tier launch

// MARK: - Search Mode Toggle View
struct SearchModeToggleView: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var showingPremiumUpgrade = false

    var body: some View {
        HStack(spacing: 12) {
            // Simple toggle switch like the AUTO example you showed
            HStack(spacing: 0) {
                // Direct mode button
                Button(action: {
                    userPreferences.setSearchMode(.direct)
                }) {
                    Text("Direct")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(userPreferences.getSearchMode() == .direct ? .white : Color.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            userPreferences.getSearchMode() == .direct ?
                            Color.focusBlue : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PlainButtonStyle())

                // In-App mode button
                Button(action: {
                    if premiumManager.isPremiumUser || premiumManager.isTrialActive {
                        userPreferences.setSearchMode(.inApp)
                    } else {
                        showingPremiumUpgrade = true
                    }
                }) {
                    HStack(spacing: 4) {
                        Text("In-App")
                            .font(.caption)
                            .fontWeight(.medium)

                        // Premium crown indicator
                        if !premiumManager.isPremiumUser && !premiumManager.isTrialActive {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                    .foregroundColor(userPreferences.getSearchMode() == .inApp ? .white : Color.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        userPreferences.getSearchMode() == .inApp ?
                        Color.focusBlue : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(!premiumManager.isPremiumUser && !premiumManager.isTrialActive ? 0.7 : 1.0)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
            )

            Spacer()
        }
        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumUpgradeView()
        }
    }
}

#Preview {
    ContentView()
}