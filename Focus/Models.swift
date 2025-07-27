import Foundation
import SwiftUI
import UIKit
import SafariServices
import WebKit

// MARK: - Extensions
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

// MARK: - Search Error Types
enum SearchError: Error {
    case invalidQuery
    case failedToOpenURL
    case networkError
    case noResults
}

// MARK: - User Preferences & Settings
struct UserPreferences: Codable {
    var preferredLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    var autoDetectLanguage: Bool = true
    var enableDoNotDisturb: Bool = false
    var platformOrder: [Platform] = Platform.allCases
    var searchMode: SearchMode = .direct
    var dailySearchLimit: Int = 20
    var hasSeenOnboarding: Bool = false

    enum SearchMode: String, Codable, CaseIterable {
        case direct = "direct"
        case inApp = "in_app"

        var displayName: String {
            switch self {
            case .direct: return "Direct Search"
            case .inApp: return "In-App Browsing"
            }
        }
    }

    // Custom coding keys to handle Platform array
    enum CodingKeys: String, CodingKey {
        case preferredLanguage, autoDetectLanguage, enableDoNotDisturb
        case platformOrder, searchMode, dailySearchLimit, hasSeenOnboarding
    }

    init() {
        // Default initializer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        preferredLanguage = try container.decodeIfPresent(String.self, forKey: .preferredLanguage) ?? "en"
        autoDetectLanguage = try container.decodeIfPresent(Bool.self, forKey: .autoDetectLanguage) ?? true
        enableDoNotDisturb = try container.decodeIfPresent(Bool.self, forKey: .enableDoNotDisturb) ?? false
        searchMode = try container.decodeIfPresent(SearchMode.self, forKey: .searchMode) ?? .direct
        dailySearchLimit = try container.decodeIfPresent(Int.self, forKey: .dailySearchLimit) ?? 20
        hasSeenOnboarding = try container.decodeIfPresent(Bool.self, forKey: .hasSeenOnboarding) ?? false

        // Handle platform order with fallback
        if let platformStrings = try? container.decode([String].self, forKey: .platformOrder) {
            platformOrder = platformStrings.compactMap { Platform(rawValue: $0) }
            if platformOrder.isEmpty {
                platformOrder = Platform.allCases
            }
        } else {
            platformOrder = Platform.allCases
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(preferredLanguage, forKey: .preferredLanguage)
        try container.encode(autoDetectLanguage, forKey: .autoDetectLanguage)
        try container.encode(enableDoNotDisturb, forKey: .enableDoNotDisturb)
        try container.encode(platformOrder.map { $0.rawValue }, forKey: .platformOrder)
        try container.encode(searchMode, forKey: .searchMode)
        try container.encode(dailySearchLimit, forKey: .dailySearchLimit)
        try container.encode(hasSeenOnboarding, forKey: .hasSeenOnboarding)
    }
}

// MARK: - Usage Analytics
struct UsageAnalytics: Codable {
    var totalSearches: Int = 0
    var searchesByPlatform: [String: Int] = [:]
    var dailySearches: [String: Int] = [:] // Date string -> count
    var timeSpentOnPlatforms: [String: TimeInterval] = [:]
    var lastResetDate: Date = Date()
    var averageTimePerSearch: TimeInterval = 30.0 // seconds

    // Custom coding keys
    enum CodingKeys: String, CodingKey {
        case totalSearches, searchesByPlatform, dailySearches
        case timeSpentOnPlatforms, lastResetDate, averageTimePerSearch
    }

    init() {
        // Default initializer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalSearches = try container.decodeIfPresent(Int.self, forKey: .totalSearches) ?? 0
        searchesByPlatform = try container.decodeIfPresent([String: Int].self, forKey: .searchesByPlatform) ?? [:]
        dailySearches = try container.decodeIfPresent([String: Int].self, forKey: .dailySearches) ?? [:]
        timeSpentOnPlatforms = try container.decodeIfPresent([String: TimeInterval].self, forKey: .timeSpentOnPlatforms) ?? [:]
        lastResetDate = try container.decodeIfPresent(Date.self, forKey: .lastResetDate) ?? Date()
        averageTimePerSearch = try container.decodeIfPresent(TimeInterval.self, forKey: .averageTimePerSearch) ?? 30.0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalSearches, forKey: .totalSearches)
        try container.encode(searchesByPlatform, forKey: .searchesByPlatform)
        try container.encode(dailySearches, forKey: .dailySearches)
        try container.encode(timeSpentOnPlatforms, forKey: .timeSpentOnPlatforms)
        try container.encode(lastResetDate, forKey: .lastResetDate)
        try container.encode(averageTimePerSearch, forKey: .averageTimePerSearch)
    }

    mutating func recordSearch(platform: Platform) {
        totalSearches += 1
        searchesByPlatform[platform.rawValue, default: 0] += 1

        let dateKey = DateFormatter.dayFormatter.string(from: Date())
        dailySearches[dateKey, default: 0] += 1
    }

    func getTodaysSearchCount() -> Int {
        let today = DateFormatter.dayFormatter.string(from: Date())
        return dailySearches[today, default: 0]
    }

    func getTimeSaved() -> TimeInterval {
        // Based on research: average time spent on social media before finding content
        let averageWastedTime: TimeInterval = 180.0 // 3 minutes per search
        let timeSavedPerSearch = averageWastedTime - averageTimePerSearch
        return Double(totalSearches) * timeSavedPerSearch
    }

    func getTimeSavedToday() -> TimeInterval {
        let todaySearches = getTodaysSearchCount()
        let averageWastedTime: TimeInterval = 180.0
        let timeSavedPerSearch = averageWastedTime - averageTimePerSearch
        return Double(todaySearches) * timeSavedPerSearch
    }
}

// MARK: - Search History
struct SearchHistoryItem: Codable, Identifiable {
    let id: UUID
    let query: String
    let platform: Platform
    let timestamp: Date
    let resultCount: Int?

    // Custom coding keys
    enum CodingKeys: String, CodingKey {
        case id, query, platform, timestamp, resultCount
    }

    init(query: String, platform: Platform, timestamp: Date = Date(), resultCount: Int? = nil) {
        self.id = UUID()
        self.query = query
        self.platform = platform
        self.timestamp = timestamp
        self.resultCount = resultCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        query = try container.decode(String.self, forKey: .query)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount)

        // Handle platform decoding
        let platformString = try container.decode(String.self, forKey: .platform)
        guard let decodedPlatform = Platform(rawValue: platformString) else {
            throw DecodingError.dataCorruptedError(forKey: .platform, in: container, debugDescription: "Invalid platform value")
        }
        platform = decodedPlatform
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(query, forKey: .query)
        try container.encode(platform.rawValue, forKey: .platform)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(resultCount, forKey: .resultCount)
    }

    var timeAgo: String {
        return LocalizationManager.shared.formatRelativeTime(for: timestamp)
    }
}

// MARK: - Premium Features
enum PremiumFeature: String, CaseIterable {
    case inAppBrowsing = "in_app_browsing"
    case searchHistory = "search_history"
    case doNotDisturb = "do_not_disturb"
    case advancedSearch = "advanced_search"
    case contentSummary = "content_summary"
    case unlimitedSearches = "unlimited_searches"

    var displayName: String {
        switch self {
        case .inAppBrowsing: return "In-App Browsing"
        case .searchHistory: return "Search History"
        case .doNotDisturb: return "Auto Do Not Disturb"
        case .advancedSearch: return "Advanced Search Filters"
        case .contentSummary: return "Content Summarization"
        case .unlimitedSearches: return "Unlimited Searches"
        }
    }

    var description: String {
        switch self {
        case .inAppBrowsing: return "Browse search results within the app"
        case .searchHistory: return "Keep track of your search history"
        case .doNotDisturb: return "Automatically enable Do Not Disturb when opening the app"
        case .advancedSearch: return "Use advanced filters for more precise searches"
        case .contentSummary: return "Get AI-powered summaries of videos and posts"
        case .unlimitedSearches: return "Remove daily search limits"
        }
    }
}

// MARK: - Platform Definitions
enum Platform: String, CaseIterable {
    case youtube = "youtube"
    case reddit = "reddit"
    case x = "x"
    case tiktok = "tiktok"
    case instagram = "instagram"
    case facebook = "facebook"
    
    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .reddit: return "Reddit"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .x: return "X"
        case .tiktok: return "TikTok"
        }
    }
    
    /// The asset name for the real app icon in Assets.xcassets
    var assetName: String {
        switch self {
        case .youtube: return "icon_youtube"
        case .reddit: return "icon_reddit"
        case .instagram: return "icon_instagram"
        case .facebook: return "icon_facebook"
        case .x: return "icon_x"
        case .tiktok: return "icon_tiktok"
        }
    }
    
    var icon: String {
        switch self {
        case .youtube: return "play.fill"
        case .reddit: return "message.fill"
        case .instagram: return "camera.fill"
        case .facebook: return "f.square.fill"
        case .x: return "xmark"
        case .tiktok: return "music.note"
        }
    }
    
    var color: Color {
        switch self {
        case .youtube: return Color(red: 0.95, green: 0.13, blue: 0.13)
        case .reddit: return Color.orange
        case .instagram: return Color.purple
        case .facebook: return Color(red: 0.23, green: 0.35, blue: 0.60)
        case .x: return Color(red: 0.13, green: 0.13, blue: 0.18)
        case .tiktok: return Color(red: 0.0, green: 0.0, blue: 0.0)
        }
    }
    
    var searchURL: String {
        switch self {
        case .youtube: return "https://www.youtube.com/results?search_query="
        case .reddit: return "https://www.reddit.com/search/?q="
        case .instagram: return "https://www.instagram.com/explore/search/?q="
        case .facebook: return "https://www.facebook.com/search/top/?q="
        case .x: return "https://x.com/search?q="
        case .tiktok: return "https://www.tiktok.com/search?q="
        }
    }
    
    var appScheme: String? {
        switch self {
        case .youtube: return "youtube://"
        case .reddit: return "reddit://"
        case .instagram: return "instagram://"
        case .facebook: return "fb://"
        case .x: return "x://"
        case .tiktok: return "tiktok://"
        }
    }
}



// Search suggestion model
struct SearchSuggestion: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let type: SuggestionType
    let platform: Platform?
    
    enum SuggestionType {
        case recent
        case popular
        case trending
        case related
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: SearchSuggestion, rhs: SearchSuggestion) -> Bool {
        lhs.text == rhs.text
    }
}

// Search result model
struct SearchResult: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let url: String
    let thumbnailURL: String?
    let platform: Platform
    let type: ResultType
    let metadata: [String: String]
    let previewContent: String?
    let directAction: DirectAction?
    
    init(title: String, description: String, url: String, thumbnailURL: String? = nil, platform: Platform, type: ResultType, metadata: [String: String] = [:], previewContent: String? = nil, directAction: DirectAction? = nil) {
        self.id = "\(platform.rawValue)_\(url.hashValue)"
        self.title = title
        self.description = description
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.platform = platform
        self.type = type
        self.metadata = metadata
        self.previewContent = previewContent
        self.directAction = directAction
    }
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    enum ResultType: Equatable {
        case video
        case post
        case article
        case image
        case user
        case website
        case news
        case product
    }
    
    enum DirectAction: Equatable {
        case openInApp
        case openInBrowser
        case share
        case bookmark
    }
}

// MARK: - YouTube API Models
struct YouTubeSearchResponse: Codable {
    let items: [YouTubeSearchItem]
    let nextPageToken: String?
    let prevPageToken: String?
    let pageInfo: YouTubePageInfo
}

struct YouTubePageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct YouTubeSearchItem: Codable {
    let id: YouTubeVideoID
    let snippet: YouTubeSnippet
}

struct YouTubeVideoID: Codable {
    let videoId: String?
}

struct YouTubeSnippet: Codable {
    let title: String
    let description: String
    let thumbnails: YouTubeThumbnails
    let channelTitle: String
    let publishedAt: String
}

struct YouTubeThumbnails: Codable {
    let medium: YouTubeThumbnail?
    let high: YouTubeThumbnail?
}

struct YouTubeThumbnail: Codable {
    let url: String
}

// Search service
class SearchService: ObservableObject {
    static let shared = SearchService()
    
    @Published var recentSearches: [String] = []
    @Published var popularSearches: [String] = []
    // Removed search result storage - free tier uses direct navigation only
    
    // Removed YouTube API and search functions - free tier uses direct navigation only
    
    // Free tier launch - no premium features
    @Published var isPremiumUser = false
    
    private init() {
        loadRecentSearches()
        loadPopularSearches()
        // Free tier launch - no premium functionality
    }
    
    func getSuggestions(for query: String, platform: Platform) -> [SearchSuggestion] {
        var suggestions: [SearchSuggestion] = []
        
        // Add recent searches
        let recentMatches = recentSearches.filter { $0.lowercased().contains(query.lowercased()) }
        suggestions.append(contentsOf: recentMatches.prefix(3).map { 
            SearchSuggestion(text: $0, type: .recent, platform: nil) 
        })
        
        // Add platform-specific suggestions
        let platformSuggestions = getPlatformSuggestions(for: platform, query: query)
        suggestions.append(contentsOf: platformSuggestions)
        
        // Add trending suggestions
        let trendingSuggestions = getTrendingSuggestions(for: platform)
        suggestions.append(contentsOf: trendingSuggestions)
        
        return Array(Set(suggestions)).prefix(8).map { $0 }
    }
    
    private func getPlatformSuggestions(for platform: Platform, query: String) -> [SearchSuggestion] {
        switch platform {
        case .youtube:
            return [
                "\(query) tutorial",
                "\(query) review",
                "\(query) 2024",
                "how to \(query)"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .reddit:
            return [
                "r/\(query)",
                "\(query) reddit",
                "\(query) discussion",
                "\(query) community"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .instagram:
            return [
                "\(query)",
                "\(query) photos",
                "\(query) reels",
                "\(query) stories"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .facebook:
            return [
                "\(query) facebook",
                "\(query) group",
                "\(query) page",
                "\(query) event"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .x:
            return [
                "#\(query)",
                "\(query) twitter",
                "\(query) news",
                "\(query) trending"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .tiktok:
            return [
                "#\(query)",
                "\(query) challenge",
                "\(query) dance",
                "\(query) trending"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        }
    }
    
    private func getTrendingSuggestions(for platform: Platform) -> [SearchSuggestion] {
        switch platform {
        case .youtube:
            return [
                "iOS 17 tutorial",
                "SwiftUI tips",
                "App development",
                "Coding tutorial"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .reddit:
            return [
                "r/iOSProgramming",
                "r/swift",
                "r/apple",
                "r/technology"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .instagram:
            return [
                "#photography",
                "#reels",
                "#art",
                "#fashion"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .facebook:
            return [
                "local events",
                "news",
                "marketplace",
                "groups"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .x:
            return [
                "#trending",
                "breaking news",
                "#technology",
                "#sports"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .tiktok:
            return [
                "#fyp",
                "#trending",
                "#viral",
                "#dance"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        }
    }
    
    // Removed searchYouTube function - free tier uses direct navigation only
    
    func searchYouTubeFallback(query: String, completion: @escaping ([SearchResult]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        
        let results = [
            SearchResult(
                title: "Search \"\(query)\" on YouTube",
                description: "Find videos about \(query)",
                url: "https://www.youtube.com/results?search_query=\(encodedQuery)",
                thumbnailURL: nil,
                platform: .youtube,
                type: .video,
                metadata: ["domain": "youtube.com", "query": query, "type": "search"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\(query) tutorial",
                description: "Find tutorials about \(query) on YouTube",
                url: "https://www.youtube.com/results?search_query=\(encodedQuery)+tutorial",
                thumbnailURL: nil,
                platform: .youtube,
                type: .video,
                metadata: ["domain": "youtube.com", "query": query, "type": "tutorial"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\(query) review",
                description: "Find reviews about \(query) on YouTube",
                url: "https://www.youtube.com/results?search_query=\(encodedQuery)+review",
                thumbnailURL: nil,
                platform: .youtube,
                type: .video,
                metadata: ["domain": "youtube.com", "query": query, "type": "review"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "How to \(query)",
                description: "Find how-to videos about \(query)",
                url: "https://www.youtube.com/results?search_query=how+to+\(encodedQuery)",
                thumbnailURL: nil,
                platform: .youtube,
                type: .video,
                metadata: ["domain": "youtube.com", "query": query, "type": "howto"],
                previewContent: nil,
                directAction: .openInApp
            )
        ]
        
        print("YouTube Fallback: Created \(results.count) helpful search links")
        completion(results)
    }
    
    /// Main search function that handles platform-specific search logic
    func search(query: String, platform: Platform, completion: @escaping (Result<Void, SearchError>) -> Void) {
        // Allow empty queries for TikTok since users input search in WebView
        if platform != .tiktok {
            guard !query.isEmpty else {
                completion(.failure(SearchError.invalidQuery))
                return
            }
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(SearchError.invalidQuery))
            return
        }
        
        // Smart approach: Try native apps on real devices, browser-first in simulator
        if URLSchemeHandler.shared.canOpenNativeApp(platform: platform) {
            print("📱 Native app available for \(platform.displayName)")
            
            // DUAL APPROACH: Native apps first, then smart browser fallback
            let nativeURL: String?
            var shouldTryNative = false
            var needsSpecialHandling = false
            
            switch platform {
            case .youtube:
                // YouTube app DOES support search URLs perfectly
                nativeURL = "youtube://www.youtube.com/results?search_query=\(encodedQuery)"
                shouldTryNative = true
            case .reddit:
                // Reddit app DOES support search URLs perfectly
                nativeURL = "reddit://www.reddit.com/search/?q=\(encodedQuery)"
                shouldTryNative = true
            case .instagram:
                // Instagram app supports hashtags and users perfectly
                if query.hasPrefix("@") {
                    let cleanQuery = query.replacingOccurrences(of: "@", with: "")
                    nativeURL = "instagram://user?username=\(cleanQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cleanQuery)"
                    shouldTryNative = true
                    print("📱 Instagram user search: \(cleanQuery)")
                } else {
                    // For all other queries, use hashtag format (works great as-is)
                    nativeURL = "instagram://tag?name=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
                    shouldTryNative = true
                    print("📱 Instagram hashtag search: \(query)")
                }
            case .x:
                // X/Twitter app DOES support search URLs perfectly
                nativeURL = "twitter://search?query=\(encodedQuery)"
                shouldTryNative = true
            case .facebook:
                // Facebook app works with posts search URL format
                nativeURL = "https://www.facebook.com/search/posts/?q=\(encodedQuery)"
                shouldTryNative = true
                needsSpecialHandling = false
                print("📱 Opening Facebook app with posts search")
            case .tiktok:
                // TikTok app works with web search URL format
                nativeURL = "https://www.tiktok.com/search?q=\(encodedQuery)"
                shouldTryNative = true
                needsSpecialHandling = false
                print("📱 Opening TikTok app with search")
            }
            
            // Try native app first if supported
            if shouldTryNative, let nativeURL = nativeURL {
                print("🚀 Trying native app URL: \(nativeURL)")
                
                if needsSpecialHandling {
                    // SMART DUAL APPROACH: App + clipboard + browser fallback
                    DispatchQueue.main.async {
                        UIPasteboard.general.string = query
                        print("📋 Copied '\(query)' to clipboard for app use")
                        
                        if let url = URL(string: nativeURL) {
                            UIApplication.shared.open(url) { appSuccess in
                                if appSuccess {
                                    print("✅ Opened \(platform.displayName) app - search query in clipboard!")
                                    print("💡 Paste '\(query)' in the app's search bar")
                                    
                                    // Also provide browser option after a delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        print("🌐 Browser option: \(self.getBrowserURL(platform: platform, query: query))")
                                    }
                                    completion(.success(()))
                                } else {
                                    print("❌ App failed, falling back to browser")
                                    self.openBrowserSearch(platform: platform, query: query, completion: completion)
                                }
                            }
                        } else {
                            print("❌ Invalid native URL, using browser")
                            self.openBrowserSearch(platform: platform, query: query, completion: completion)
                        }
                    }
                } else {
                    // Standard native app approach for platforms with working URL schemes
                    if let url = URL(string: nativeURL) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(url) { success in
                                if success {
                                    print("✅ Successfully opened \(platform.displayName) app with search")
                                    completion(.success(()))
                                } else {
                                    print("❌ Native app failed, falling back to browser")
                                    self.openBrowserSearch(platform: platform, query: query, completion: completion)
                                }
                            }
                        }
                    } else {
                        print("❌ Invalid native URL, falling back to browser")
                        openBrowserSearch(platform: platform, query: query, completion: completion)
                    }
                }
            } else {
                // Use browser for platforms that don't support native URLs
                print("🌐 Using browser for \(platform.displayName) search")
                openBrowserSearch(platform: platform, query: query, completion: completion)
            }
        } else {
            // Simulator or no native app - use browser
            print("🌐 Using browser for \(platform.displayName)")
            openBrowserSearch(platform: platform, query: query, completion: completion)
        }
    }
    
    /// Helper function to open browser search
    private func openBrowserSearch(platform: Platform, query: String, completion: @escaping (Result<Void, SearchError>) -> Void) {
        let browserURL = getBrowserURL(platform: platform, query: query)
        guard let url = URL(string: browserURL) else {
            completion(.failure(SearchError.failedToOpenURL))
            return
        }
        
        print("🌐 Opening browser URL: \(browserURL)")
        
        // Special handling for TikTok to ensure search query is filled
        if platform == .tiktok {
            openTikTokWithSafariController(url: url, query: query, completion: completion)
        } else {
            // Use standard browser opening for other platforms
            UIApplication.shared.open(url) { success in
                DispatchQueue.main.async {
                    completion(success ? .success(()) : .failure(SearchError.failedToOpenURL))
                }
            }
        }
    }
    
    
    /// Special function to open TikTok with Safari View Controller and ensure search query is filled
    private func openTikTokWithSafariController(url: URL, query: String, completion: @escaping (Result<Void, SearchError>) -> Void) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                // Fallback to regular browser opening
                print("🌐 WebView fallback: Opening TikTok in Safari")
                UIApplication.shared.open(url) { success in
                    DispatchQueue.main.async {
                        completion(success ? .success(()) : .failure(SearchError.failedToOpenURL))
                    }
                }
                return
            }
            
            // Simple WebView approach - let user search manually
            print("📱 Opening TikTok WebView for manual search")
            let tiktokController = TikTokSearchViewController(url: url, searchQuery: query)
            let navController = UINavigationController(rootViewController: tiktokController)
            
            // Configure presentation style for better appearance
            navController.modalPresentationStyle = .pageSheet
            if let sheet = navController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = false
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            
            // Present the TikTok controller
            rootViewController.present(navController, animated: true) {
                completion(.success(()))
            }
        }
    }

    
    /// Direct search function - immediately opens platform search without showing results
    /// Prioritizes native apps over browser for better UX
    func directSearch(query: String, platform: Platform) -> Bool {
        // Only add to recent searches if query is not empty
        if !query.isEmpty {
            addToRecentSearches(query)
        }
        
        search(query: query, platform: platform) { result in
            switch result {
            case .success:
                print("✅ Search completed successfully")
            case .failure(let error):
                print("❌ Search failed: \(error)")
            }
        }
        return true
    }
    
    private func getBrowserURL(platform: Platform, query: String) -> String {
        // Use LanguageManager for localized URLs
        return LanguageManager.shared.getLocalizedSearchURL(for: platform, query: query)
    }
    
    // Removed loadMoreResults - free tier uses direct navigation only
    
    private func addToRecentSearches(_ query: String) {
        if !recentSearches.contains(query) {
            recentSearches.insert(query, at: 0)
            if recentSearches.count > 10 {
                recentSearches = Array(recentSearches.prefix(10))
            }
            saveRecentSearches()
        }
    }
    
    private func loadRecentSearches() {
        if let data = UserDefaults.standard.data(forKey: "recentSearches"),
           let searches = try? JSONDecoder().decode([String].self, from: data) {
            recentSearches = searches
        }
    }
    
    private func saveRecentSearches() {
        if let data = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(data, forKey: "recentSearches")
        }
    }
    
    private func loadPopularSearches() {
        popularSearches = [
            "iOS tutorial",
            "SwiftUI",
            "App development",
            "Coding tips",
            "Design patterns"
        ]
    }
    
    func searchTikTok(query: String, completion: @escaping ([SearchResult]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("TikTok Search: Failed to encode query")
            completion([])
            return
        }
        
        let urlString = "https://www.tiktok.com/search?q=\(encodedQuery)&t=\(Int(Date().timeIntervalSince1970))"
        guard let url = URL(string: urlString) else {
            print("TikTok Search: Failed to create URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        // Use desktop User-Agent to get proper TikTok search page
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        print("TikTok Search: Starting request for query: \(query)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("TikTok Search: Network error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("TikTok Search: No data received")
                completion([])
                return
            }
            
            print("TikTok Search: Received \(data.count) bytes of data")
            
            let htmlString = String(data: data, encoding: .utf8) ?? ""
            print("TikTok Search: HTML length: \(htmlString.count)")
            
            let results = self.parseTikTokResults(html: htmlString, query: query)
            print("TikTok Search: Parsed \(results.count) results")
            completion(results)
        }
        task.resume()
    }
    
    func searchReddit(query: String, after: String? = nil, completion: @escaping ([SearchResult], String?, Bool) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Reddit Search: Failed to encode query")
            completion([], nil, false)
            return
        }
        
        // Use Reddit's JSON API - no authentication needed!
        var urlString = "https://www.reddit.com/search.json?q=\(encodedQuery)&sort=relevance&limit=25"
        
        // Add after token for pagination
        if let after = after {
            urlString += "&after=\(after)"
        }
        
        guard let url = URL(string: urlString) else {
            print("Reddit Search: Failed to create URL")
            completion([], nil, false)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Focus iOS App/1.0", forHTTPHeaderField: "User-Agent")
        
        print("Reddit Search: Starting request for query: \(query)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Reddit Search: Network error: \(error.localizedDescription)")
                completion([], nil, false)
                return
            }
            
            guard let data = data else {
                print("Reddit Search: No data received")
                completion([], nil, false)
                return
            }
            
            print("Reddit Search: Received \(data.count) bytes of data")
            
            let (results, afterToken, hasMore) = self.parseRedditResults(data: data, query: query)
            print("Reddit Search: Parsed \(results.count) results, hasMore: \(hasMore)")
            completion(results, afterToken, hasMore)
        }
        task.resume()
    }
    
    func searchInstagram(query: String, completion: @escaping ([SearchResult]) -> Void) {
        // Instagram doesn't have a public search API and blocks direct search URLs, so we'll create helpful alternatives
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        
        let results = [
            SearchResult(
                title: "Search \"\(query)\" on Instagram",
                description: "Find posts and accounts about \(query) on Instagram",
                url: "https://www.instagram.com/explore/tags/\(query.replacingOccurrences(of: "#", with: ""))/" ,
                thumbnailURL: nil,
                platform: .instagram,
                type: .post,
                metadata: ["domain": "instagram.com", "query": query, "type": "hashtag"],
                previewContent: "Explore content about \(query) on Instagram",
                directAction: .openInApp
            ),
            SearchResult(
                title: "Search \"\(query)\" via Google",
                description: "Find Instagram content about \(query) through Google search",
                url: "https://www.google.com/search?q=site:instagram.com+\(encodedQuery)",
                thumbnailURL: nil,
                platform: .instagram,
                type: .post,
                metadata: ["domain": "google.com", "query": query, "type": "google_search"],
                previewContent: "Google search for Instagram content (works better than direct Instagram search)",
                directAction: .openInBrowser
            ),
            SearchResult(
                title: "Open Instagram App",
                description: "Search for \"\(query)\" in the Instagram app",
                url: "instagram://app",
                thumbnailURL: nil,
                platform: .instagram,
                type: .post,
                metadata: ["domain": "instagram.com", "query": query, "type": "app_search"],
                previewContent: "Search query will be copied to clipboard for easy pasting",
                directAction: .openInApp
            )
        ]
        
        print("Instagram Search: Created \(results.count) helpful search alternatives")
        completion(results)
    }
    
    func searchFacebook(query: String, completion: @escaping ([SearchResult]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        
        let results = [
            SearchResult(
                title: "Search \"\(query)\" on Facebook",
                description: "Find posts, pages, and people on Facebook",
                url: "https://www.facebook.com/search/top/?q=\(encodedQuery)",
                thumbnailURL: nil,
                platform: .facebook,
                type: .post,
                metadata: ["domain": "facebook.com", "query": query, "type": "general"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\(query) • Facebook Pages",
                description: "Find Facebook pages about \(query)",
                url: "https://www.facebook.com/search/pages/?q=\(encodedQuery)",
                thumbnailURL: nil,
                platform: .facebook,
                type: .website,
                metadata: ["domain": "facebook.com", "query": query, "type": "pages"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\(query) • Groups",
                description: "Find Facebook groups about \(query)",
                url: "https://www.facebook.com/search/groups/?q=\(encodedQuery)",
                thumbnailURL: nil,
                platform: .facebook,
                type: .website,
                metadata: ["domain": "facebook.com", "query": query, "type": "groups"],
                previewContent: nil,
                directAction: .openInApp
            )
        ]
        
        print("Facebook Search: Created \(results.count) helpful search links")
        completion(results)
    }
    
    func searchX(query: String, completion: @escaping ([SearchResult]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        
        let results = [
            SearchResult(
                title: "Search \"\(query)\" on X",
                description: "Find tweets, accounts, and trending topics",
                url: "https://x.com/search?q=\(encodedQuery)&src=typed_query",
                thumbnailURL: nil,
                platform: .x,
                type: .post,
                metadata: ["domain": "x.com", "query": query, "type": "general"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\"\(query)\" • Latest Tweets",
                description: "See the latest tweets about \(query)",
                url: "https://x.com/search?q=\(encodedQuery)&src=typed_query&f=live",
                thumbnailURL: nil,
                platform: .x,
                type: .post,
                metadata: ["domain": "x.com", "query": query, "type": "latest"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\"\(query)\" • Top Tweets",
                description: "See the most popular tweets about \(query)",
                url: "https://x.com/search?q=\(encodedQuery)&src=typed_query&f=top",
                thumbnailURL: nil,
                platform: .x,
                type: .post,
                metadata: ["domain": "x.com", "query": query, "type": "top"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "#\(query)",
                description: "Explore hashtag #\(query) on X",
                url: "https://x.com/hashtag/\(query.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: " ", with: ""))",
                thumbnailURL: nil,
                platform: .x,
                type: .post,
                metadata: ["domain": "x.com", "query": query, "type": "hashtag"],
                previewContent: nil,
                directAction: .openInApp
            )
        ]
        
        print("X Search: Created \(results.count) helpful search links")
        completion(results)
    }
    
    // MARK: - HTML Parsing Functions
    
    private func parseTikTokResults(html: String, query: String) -> [SearchResult] {
        var results: [SearchResult] = []
        
        print("TikTok Parse: Starting to parse HTML...")
        
        // Very simple but effective approach: look for any HTTPS links with text
        let patterns = [
            // Pattern 1: Links with title text
            #"<a[^>]*href="(https://[^"]*)"[^>]*>([^<]{10,100})</a>"#,
            // Pattern 2: Links in headers
            #"href="(https://[^"]*)"[^>]*><h[1-6][^>]*>([^<]{5,})</h[1-6]>"#,
            // Pattern 3: Any decent link with text
            #"<a[^>]*href="(https://[^"]*)"[^>]*>\s*([A-Za-z][^<]{8,80})\s*</a>"#
        ]
        
        var seenURLs = Set<String>()
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { continue }
            
            let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: html.count))
            
            for match in matches {
                if results.count >= 10 { break }
                
                guard match.numberOfRanges >= 3 else { continue }
                
                let urlRange = match.range(at: 1)
                let titleRange = match.range(at: 2)
                
                guard urlRange.location != NSNotFound && titleRange.location != NSNotFound else { continue }
                
                let url = String(html[Range(urlRange, in: html)!])
                let title = String(html[Range(titleRange, in: html)!])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                
                // Filter out unwanted URLs and ensure quality
                if !url.contains("tiktok.com") &&
                   !url.contains("youtube.com") &&
                   title.count >= 10 &&
                   title.count <= 100 &&
                   !seenURLs.contains(url) {
                    
                    seenURLs.insert(url)
                    
                    let result = SearchResult(
                        title: title,
                        description: "Search result from \(extractDomain(from: url))",
                        url: url,
                        thumbnailURL: nil,
                        platform: .tiktok,
                        type: .website,
                        metadata: [
                            "domain": extractDomain(from: url),
                            "query": query
                        ],
                        previewContent: nil,
                        directAction: .openInBrowser
                    )
                    results.append(result)
                    print("TikTok: Found result: \(title)")
                }
            }
        }
        
        // If still no results, create helpful fallback
        if results.isEmpty {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return results
            }
            
            let fallbackResults = [
                SearchResult(
                    title: "Search \"\(query)\" on TikTok",
                    description: "Find videos and creators about \(query)",
                    url: "https://www.tiktok.com/search?q=\(encodedQuery)&t=\(Int(Date().timeIntervalSince1970))",
                    thumbnailURL: nil,
                    platform: .tiktok,
                    type: .video,
                    metadata: ["domain": "tiktok.com", "query": query, "type": "search"],
                    previewContent: nil,
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "#\(query)",
                    description: "Explore hashtag #\(query) on TikTok",
                    url: "https://www.tiktok.com/tag/\(query.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: " ", with: ""))",
                    thumbnailURL: nil,
                    platform: .tiktok,
                    type: .video,
                    metadata: ["domain": "tiktok.com", "query": query, "type": "hashtag"],
                    previewContent: nil,
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "\(query) • Trending",
                    description: "See trending TikTok videos about \(query)",
                    url: "https://www.tiktok.com/search?q=\(encodedQuery)&t=\(Int(Date().timeIntervalSince1970))",
                    thumbnailURL: nil,
                    platform: .tiktok,
                    type: .video,
                    metadata: ["domain": "tiktok.com", "query": query, "type": "trending"],
                    previewContent: nil,
                    directAction: .openInApp
                )
            ]
            results.append(contentsOf: fallbackResults)
        }
        
        return results
    }
    
    private func extractDomain(from urlString: String) -> String {
        guard let url = URL(string: urlString) else { return "Unknown" }
        return url.host ?? "Unknown"
    }
    
    private func parseRedditResults(data: Data, query: String) -> ([SearchResult], String?, Bool) {
        var results: [SearchResult] = []
        var afterToken: String? = nil
        var hasMore = false
        
        do {
            // Parse Reddit's JSON response
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dataObj = json["data"] as? [String: Any],
               let children = dataObj["children"] as? [[String: Any]] {
                
                // Get pagination info
                afterToken = dataObj["after"] as? String
                hasMore = afterToken != nil
                
                for child in children {
                    if let data = child["data"] as? [String: Any],
                       let title = data["title"] as? String,
                       let subreddit = data["subreddit"] as? String,
                       let permalink = data["permalink"] as? String,
                       let author = data["author"] as? String {
                        
                        let score = data["score"] as? Int ?? 0
                        let numComments = data["num_comments"] as? Int ?? 0
                        let selftext = data["selftext"] as? String ?? ""
                        let isVideo = data["is_video"] as? Bool ?? false
                        let thumbnail = data["thumbnail"] as? String
                        let url = data["url"] as? String ?? ""
                        
                        // Create description
                        var description = "r/\(subreddit) • by u/\(author)"
                        if score > 0 {
                            description += " • \(score) upvotes"
                        }
                        if numComments > 0 {
                            description += " • \(numComments) comments"
                        }
                        
                        // Determine result type
                        let resultType: SearchResult.ResultType = isVideo ? .video : 
                                       (url.contains(".jpg") || url.contains(".png") || url.contains(".gif")) ? .image : .post
                        
                        // Better thumbnail handling - use multiple sources
                        var thumbnailURL: String? = nil
                        
                        // First, try the direct URL if it's an image
                        if (url.contains(".jpg") || url.contains(".png") || url.contains(".gif")) && url.hasPrefix("http") {
                            thumbnailURL = url
                        }
                        // Then try Reddit's preview images
                        else if let preview = data["preview"] as? [String: Any],
                                let images = preview["images"] as? [[String: Any]],
                                let firstImage = images.first,
                                let source = firstImage["source"] as? [String: Any],
                                let sourceURL = source["url"] as? String {
                            // Reddit provides HTML-encoded URLs, decode them
                            thumbnailURL = sourceURL.replacingOccurrences(of: "&amp;", with: "&")
                        }
                        // Finally fall back to thumbnail
                        else if let thumb = thumbnail, 
                                thumb.hasPrefix("http") && 
                                !thumb.contains("default") &&
                                !thumb.contains("self") &&
                                !thumb.contains("spoiler") &&
                                !thumb.contains("nsfw") {
                            thumbnailURL = thumb
                        }
                        
                        let result = SearchResult(
                            title: title,
                            description: description,
                            url: "https://www.reddit.com\(permalink)",
                            thumbnailURL: thumbnailURL,
                            platform: .reddit,
                            type: resultType,
                            metadata: [
                                "subreddit": subreddit,
                                "author": author,
                                "score": String(score),
                                "comments": String(numComments),
                                "domain": "reddit.com",
                                "original_url": url
                            ],
                            previewContent: selftext.isEmpty ? nil : String(selftext.prefix(200)),
                            directAction: .openInApp
                        )
                        
                        results.append(result)
                        
                        if results.count >= 20 { break }
                    }
                }
            }
        } catch {
            print("Reddit Parse Error: \(error.localizedDescription)")
        }
        
        // If no results found, provide helpful fallback
        if results.isEmpty {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return (results, nil, false)
            }
            
            let fallbackResults = [
                SearchResult(
                    title: "Search \"\(query)\" on Reddit",
                    description: "Find discussions and communities about \(query)",
                    url: "https://www.reddit.com/search/?q=\(encodedQuery)",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .post,
                    metadata: ["domain": "reddit.com", "query": query],
                    previewContent: nil,
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "r/\(query)",
                    description: "Visit the r/\(query) subreddit",
                    url: "https://www.reddit.com/r/\(query)/",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .website,
                    metadata: ["domain": "reddit.com", "query": query, "type": "subreddit"],
                    previewContent: nil,
                    directAction: .openInApp
                )
            ]
            results.append(contentsOf: fallbackResults)
        }
        
        return (results, afterToken, hasMore)
    }
}

// MARK: - TikTok Search View Controller
class TikTokSearchViewController: UIViewController, WKNavigationDelegate {
    private let targetURL: URL
    private let searchQuery: String
    private var webView: WKWebView!
    
    init(url: URL, searchQuery: String) {
        self.targetURL = url
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupWebView()
        setupNavigationBar()
        loadTikTokPage()
    }
    
    private func setupViewController() {
        // Set proper background color
        view.backgroundColor = UIColor.systemBackground
        
        // Configure modal presentation style
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.large()]
            presentationController.prefersGrabberVisible = false
        }
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadTikTokPage() {
        let request = URLRequest(url: targetURL)
        webView.load(request)
    }
    
    private func setupNavigationBar() {
        title = "TikTok Search"
        
        // Set proper background and appearance
        if let navigationController = navigationController {
            let navBar = navigationController.navigationBar
            navBar.prefersLargeTitles = false
            
            // Configure navigation bar appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            
            // Apply appearance
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
            
            // Set tint color for buttons
            navBar.tintColor = UIColor.systemBlue
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(dismissController)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Safari",
            style: .plain,
            target: self,
            action: #selector(openInSafari)
        )
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    
    @objc private func openInSafari() {
        dismiss(animated: true) {
            UIApplication.shared.open(self.targetURL)
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ TikTok page loaded successfully")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ TikTok page failed to load: \(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "Loading Error", 
            message: "TikTok failed to load. Would you like to open it in Safari instead?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open in Safari", style: .default) { _ in
            self.dismiss(animated: true) {
                UIApplication.shared.open(self.targetURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}

 