import SwiftUI
import WebKit

// MARK: - In-App Browser View
struct InAppBrowserView: View {
    let url: URL
    let platform: Platform
    let query: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var currentURL: URL?
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Loading indicator
                if isLoading {
                    ProgressView()
                        .frame(height: 2)
                        .scaleEffect(x: 1, y: 0.5)
                }
                
                // Web view
                WebView(
                    url: url,
                    isLoading: $isLoading,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    currentURL: $currentURL
                )
            }
            .navigationTitle(platform.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!canGoBack)
                    
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!canGoForward)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: refresh) {
                        Image(systemName: "arrow.clockwise")
                    }
                    
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(currentURL == nil)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let currentURL = currentURL {
                ShareSheet(items: [currentURL])
            }
        }
    }
    
    private func goBack() {
        NotificationCenter.default.post(name: .webViewGoBack, object: nil)
    }
    
    private func goForward() {
        NotificationCenter.default.post(name: .webViewGoForward, object: nil)
    }
    
    private func refresh() {
        NotificationCenter.default.post(name: .webViewRefresh, object: nil)
    }
}

// MARK: - WebView UIViewRepresentable
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var currentURL: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        // Configure for better mobile experience
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
            super.init()
            
            // Listen for navigation commands
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(goBack),
                name: .webViewGoBack,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(goForward),
                name: .webViewGoForward,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(refresh),
                name: .webViewRefresh,
                object: nil
            )
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func goBack() {
            if let webView = getCurrentWebView(), webView.canGoBack {
                webView.goBack()
            }
        }
        
        @objc func goForward() {
            if let webView = getCurrentWebView(), webView.canGoForward {
                webView.goForward()
            }
        }
        
        @objc func refresh() {
            getCurrentWebView()?.reload()
        }
        
        private func getCurrentWebView() -> WKWebView? {
            // This is a simplified approach - in a real implementation,
            // you'd want to maintain a reference to the current webView
            return nil
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
                self.parent.currentURL = webView.url
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow all navigation for now
            decisionHandler(.allow)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let webViewGoBack = Notification.Name("webViewGoBack")
    static let webViewGoForward = Notification.Name("webViewGoForward")
    static let webViewRefresh = Notification.Name("webViewRefresh")
}

// MARK: - Advanced Search View
struct AdvancedSearchView: View {
    let platform: Platform
    @Binding var searchQuery: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedFilters: Set<SearchFilter> = []
    @State private var dateRange: DateRange = .anyTime
    @State private var sortBy: SortOption = .relevance
    @State private var contentType: ContentType = .all
    
    var body: some View {
        NavigationView {
            Form {
                Section("Search Query") {
                    TextField("Enter your search...", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section("Content Type") {
                    Picker("Type", selection: $contentType) {
                        ForEach(ContentType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Date Range") {
                    Picker("Date", selection: $dateRange) {
                        ForEach(DateRange.allCases, id: \.self) { range in
                            Text(range.displayName).tag(range)
                        }
                    }
                }
                
                Section("Sort By") {
                    Picker("Sort", selection: $sortBy) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                }
                
                // Platform-specific filters
                if !getAvailableFilters().isEmpty {
                    Section("Filters") {
                        ForEach(getAvailableFilters(), id: \.self) { filter in
                            Toggle(filter.displayName, isOn: Binding(
                                get: { selectedFilters.contains(filter) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFilters.insert(filter)
                                    } else {
                                        selectedFilters.remove(filter)
                                    }
                                }
                            ))
                        }
                    }
                }
            }
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Search") {
                        performAdvancedSearch()
                        dismiss()
                    }
                    .disabled(searchQuery.isEmpty)
                }
            }
        }
    }
    
    private func getAvailableFilters() -> [SearchFilter] {
        switch platform {
        case .youtube:
            return [.channels, .playlists, .liveStreams]
        case .instagram:
            return [.posts, .stories, .reels, .igtv]
        case .tiktok:
            return [.trending, .hashtags, .sounds]
        case .x:
            return [.tweets, .users, .photos, .videos]
        case .facebook:
            return [.posts, .pages, .groups, .events]
        case .reddit:
            return [.posts, .comments, .communities]
        }
    }
    
    private func performAdvancedSearch() {
        // Build advanced search URL with filters
        var searchURL = platform.searchURL + searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // Add platform-specific parameters
        switch platform {
        case .youtube:
            if selectedFilters.contains(.channels) {
                searchURL += "&sp=EgIQAg%253D%253D" // Channel filter
            }
            if selectedFilters.contains(.playlists) {
                searchURL += "&sp=EgIQAw%253D%253D" // Playlist filter
            }
        case .x:
            if selectedFilters.contains(.photos) {
                searchURL += "&f=image"
            }
            if selectedFilters.contains(.videos) {
                searchURL += "&f=video"
            }
        default:
            break
        }
        
        // Open the advanced search URL
        if let url = URL(string: searchURL) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Search Filter Enums
enum SearchFilter: String, CaseIterable, Hashable {
    case channels, playlists, liveStreams
    case posts, stories, reels, igtv
    case trending, hashtags, sounds
    case tweets, users, photos, videos
    case pages, groups, events
    case comments, communities
    
    var displayName: String {
        switch self {
        case .channels: return "Channels"
        case .playlists: return "Playlists"
        case .liveStreams: return "Live Streams"
        case .posts: return "Posts"
        case .stories: return "Stories"
        case .reels: return "Reels"
        case .igtv: return "IGTV"
        case .trending: return "Trending"
        case .hashtags: return "Hashtags"
        case .sounds: return "Sounds"
        case .tweets: return "Tweets"
        case .users: return "Users"
        case .photos: return "Photos"
        case .videos: return "Videos"
        case .pages: return "Pages"
        case .groups: return "Groups"
        case .events: return "Events"
        case .comments: return "Comments"
        case .communities: return "Communities"
        }
    }
}

enum DateRange: String, CaseIterable {
    case anyTime, pastHour, pastDay, pastWeek, pastMonth, pastYear
    
    var displayName: String {
        switch self {
        case .anyTime: return "Any time"
        case .pastHour: return "Past hour"
        case .pastDay: return "Past 24 hours"
        case .pastWeek: return "Past week"
        case .pastMonth: return "Past month"
        case .pastYear: return "Past year"
        }
    }
}

enum SortOption: String, CaseIterable {
    case relevance, date, viewCount, rating
    
    var displayName: String {
        switch self {
        case .relevance: return "Relevance"
        case .date: return "Upload date"
        case .viewCount: return "View count"
        case .rating: return "Rating"
        }
    }
}

enum ContentType: String, CaseIterable {
    case all, videos, channels, playlists
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .videos: return "Videos"
        case .channels: return "Channels"
        case .playlists: return "Playlists"
        }
    }
}

#Preview {
    InAppBrowserView(
        url: URL(string: "https://www.youtube.com/results?search_query=swift")!,
        platform: .youtube,
        query: "swift"
    )
}
