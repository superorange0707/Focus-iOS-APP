import SwiftUI

struct ContentView: View {
    @State private var selectedPlatform: Platform = .youtube
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchResults: [SearchResult] = []
    @State private var showingResults = false
    @StateObject private var searchService = SearchService.shared
    
    var body: some View {
        ZStack {
            // White/blue glassmorphism background
            LinearGradient(
                colors: [
                    Color.white.opacity(0.95),
                    Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.18), // #007AFF
                    Color.white.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // App title with glass style
                VStack(spacing: 8) {
                    Text("Focus Search")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                        .shadow(color: Color.white.opacity(0.7), radius: 8, x: 0, y: 2)
                    
                    Text("Search directly, stay focused")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                .padding(.top, 48)
                .padding(.bottom, 4)
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.08), radius: 16, x: 0, y: 8)
                
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
                    
                    // Glass style search button
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
                            
                            Text(isSearching ? "Searching..." : "Search \(selectedPlatform.displayName)")
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
                
                // Recent searches section
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
                
                // Footer with app info
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
            
            // Search results overlay with enhanced animation
            if showingResults {
                SearchResultsView(
                    results: searchResults,
                    platform: selectedPlatform,
                    onDismiss: { 
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showingResults = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingResults)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        isSearching = true
        searchService.search(query: searchText, platform: selectedPlatform) { results in
            DispatchQueue.main.async {
                self.searchResults = results
                self.isSearching = false
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    self.showingResults = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 