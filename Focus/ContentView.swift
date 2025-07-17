import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedPlatform: Platform = .youtube
    @State private var searchText = ""
    @State private var isSearching = false
    // Removed showingResults state - not needed for free tier direct navigation
    @StateObject private var searchService = SearchService.shared
    
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
                // App title with better integration - no separate card, blend with background
                VStack(spacing: 8) {
                Text("Focus Search")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color.focusBlue)
                        .shadow(color: Color.backgroundPrimary.opacity(0.8), radius: 12, x: 0, y: 3)
                    
                    Text("Search directly, stay focused")
                        .font(.subheadline)
                        .foregroundColor(Color.secondaryText)
                        .fontWeight(.medium)
                    
                    // Free tier launch - no premium features
                }
                .padding(.top, 25)
                .padding(.bottom, 15)
                
                // Platform selector
                PlatformSelectorView(selectedPlatform: $selectedPlatform)
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
                        
                        // Simple info text for free tier
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.focusBlue)
                                .font(.caption2)
                            Text("Search directly in your favorite apps")
                                .font(.caption2)
                                .foregroundColor(Color.secondaryText)
                            Spacer()
                        }
                        .padding(.horizontal, 5)
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
                            
                            Text("Recent Searches")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color.secondaryText)
                            
                            Spacer()
                            
                            Button("Clear") {
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
                
                // Footer with app info - restored original
                VStack(spacing: 8) {
                    Text("Focus on what matters")
                        .font(.caption)
                        .foregroundColor(Color.focusBlue.opacity(0.7))
                    
                    Text("No distractions, just results")
                        .font(.caption2)
                        .foregroundColor(Color.tertiaryText)
                }
                .padding(.bottom, 30)
            }
            
            // Removed SearchResultsView overlay - free tier uses direct navigation only
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
        // No premium upgrade popup in free tier
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
            return "Open TikTok Search"
        }
        
        // Check if native app is available for other platforms
        if URLSchemeHandler.shared.canOpenNativeApp(platform: selectedPlatform) {
            return "Open in \(selectedPlatform.displayName) App"
        } else {
            return "Search on \(selectedPlatform.displayName)"
        }
    }
    
    private func performSearch() {
        // Special handling for TikTok - no search text required
        if selectedPlatform == .tiktok {
            // For TikTok, open search page directly where users can input their query
            hideKeyboard()
            isSearching = true
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
        
        // Free tier - always use direct search
        isSearching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Small delay for UX
            let success = searchService.directSearch(query: searchText, platform: selectedPlatform)
            self.isSearching = false
            
            if !success {
                // Show error message or fallback
                print("Failed to open \(selectedPlatform.displayName)")
            }
        }
    }
}

// Premium upgrade views removed for free tier launch

#Preview {
    ContentView()
} 