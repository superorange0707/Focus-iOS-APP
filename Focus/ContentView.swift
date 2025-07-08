import SwiftUI

struct ContentView: View {
    @State private var selectedPlatform: Platform = .youtube
    @State private var searchText = ""
    @State private var isSearching = false
    // Removed showingResults state - not needed for free tier direct navigation
    @StateObject private var searchService = SearchService.shared
    
    var body: some View {
        ZStack {
            // White/blue glassmorphism background - restored original with minimal enhancement
            LinearGradient(
                colors: [
                    Color.white.opacity(0.95),
                    Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.20), // Slightly increased from 0.18 for visibility
                    Color.white.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // App title with better integration - no separate card, blend with background
                VStack(spacing: 8) {
                Text("Focus Search")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                        .shadow(color: Color.white.opacity(0.8), radius: 12, x: 0, y: 3)
                    
                    Text("Search directly, stay focused")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                        .opacity(0.9)
                    
                    // Free tier launch - no premium features
                }
                .padding(.top, 25)
                .padding(.bottom, 15)
                
                // Platform selector
                PlatformSelectorView(selectedPlatform: $selectedPlatform)
                    .padding(.top, 2)
                
                // Search section
                VStack(spacing: 18) {
                    // Search input with glass style
                    SearchInputView(
                        searchText: $searchText,
                        platform: selectedPlatform,
                        onSearch: performSearch
                    )
                    
                    // Simple info text for free tier
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                            .font(.caption2)
                        Text("Search directly in your favorite apps")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    .opacity(0.8) // Slightly increased from 0.7 for better visibility
                    
                    // Glass style search button - restored original
                    Button(action: performSearch) {
                        HStack(spacing: 12) {
                            if isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.0, green: 0.48, blue: 1.0)))
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
                                colors: [Color(red: 0.0, green: 0.48, blue: 1.0), Color.white.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.18), radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(searchText.isEmpty || isSearching)
                    .scaleEffect(isSearching ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearching)
                }
                .padding(.horizontal, 30)
                
                // Recent searches section - restored original
                if !searchService.recentSearches.isEmpty && searchText.isEmpty {
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                                .font(.caption)
                            
                            Text("Recent Searches")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button("Clear") {
                                searchService.recentSearches.removeAll()
                            }
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(searchService.recentSearches.prefix(5), id: \.self) { recentSearch in
                                    Button(action: {
                                        searchText = recentSearch
                                        performSearch()
                                    }) {
                                        Text(recentSearch)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
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
                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.7))
                    
                    Text("No distractions, just results")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .padding(.bottom, 30)
            }
            
            // Removed SearchResultsView overlay - free tier uses direct navigation only
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
        // No premium upgrade popup in free tier
    }
    
    private func getSimpleSearchButtonText() -> String {
        // Check if native app is available
        if URLSchemeHandler.shared.canOpenNativeApp(platform: selectedPlatform) {
            return "Open in \(selectedPlatform.displayName) App"
        } else {
            return "Search on \(selectedPlatform.displayName)"
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
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