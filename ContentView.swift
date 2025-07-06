import SwiftUI

struct ContentView: View {
    @State private var selectedPlatform: Platform = .youtube
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchResults: [SearchResult] = []
    @State private var showingResults = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App title
                Text("Focus Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 50)
                
                // Platform selector
                PlatformSelectorView(selectedPlatform: $selectedPlatform)
                
                // Search section
                VStack(spacing: 20) {
                    // Search input
                    SearchInputView(
                        searchText: $searchText,
                        platform: selectedPlatform,
                        onSearch: performSearch
                    )
                    
                    // Search button
                    Button(action: performSearch) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search \(selectedPlatform.displayName)")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(searchText.isEmpty || isSearching)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            
            // Search results overlay
            if showingResults {
                SearchResultsView(
                    results: searchResults,
                    platform: selectedPlatform,
                    onDismiss: { showingResults = false }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring(), value: showingResults)
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            searchResults = SearchService.search(
                query: searchText,
                platform: selectedPlatform
            )
            isSearching = false
            showingResults = true
        }
    }
}

#Preview {
    ContentView()
} 