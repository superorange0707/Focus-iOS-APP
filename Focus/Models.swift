import Foundation
import SwiftUI
import UIKit

// Platform enum
enum Platform: String, CaseIterable {
    case youtube = "youtube"
    case reddit = "reddit"
    case instagram = "instagram"
    case facebook = "facebook"
    case x = "x"
    case tiktok = "tiktok"
    
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
        case .instagram: return "https://www.instagram.com/explore/tags/"
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
                "#\(query)",
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
    
    func search(query: String, platform: Platform, completion: @escaping ([SearchResult]) -> Void) {
        // Free tier - no in-app results, use direct search only
        completion([])
    }
    
    /// Direct search function - immediately opens platform search without showing results
    /// Prioritizes native apps over browser for better UX
    func directSearch(query: String, platform: Platform) -> Bool {
        addToRecentSearches(query)
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }
        
        print("🚀 Direct search: \(query) on \(platform.displayName)")
        
        // Smart approach: Try native apps on real devices, browser-first in simulator
        if URLSchemeHandler.shared.canOpenNativeApp(platform: platform) {
            print("📱 Native app available for \(platform.displayName)")
            
            // Use platform-specific native URL schemes
            let nativeURL: String?
            switch platform {
            case .youtube:
                nativeURL = "youtube://www.youtube.com/results?search_query=\(encodedQuery)"
            case .reddit:
                nativeURL = "reddit://www.reddit.com/search/?q=\(encodedQuery)"
            case .instagram:
                // Instagram app URL schemes
                if query.hasPrefix("#") {
                    let cleanQuery = query.replacingOccurrences(of: "#", with: "")
                    nativeURL = "instagram://tag?name=\(cleanQuery)"
                } else {
                    nativeURL = "instagram://user?username=\(query.replacingOccurrences(of: " ", with: ""))"
                }
            case .facebook:
                nativeURL = "fb://profile" // Facebook app doesn't support direct search URLs
            case .x:
                nativeURL = "x://search?query=\(encodedQuery)"
            case .tiktok:
                nativeURL = "tiktok://" // TikTok doesn't support search in URL scheme
            }
            
            if let nativeURL = nativeURL, let url = URL(string: nativeURL) {
                print("🔗 Trying native URL: \(nativeURL)")
                // Directly try to open without checking to avoid eligibility_plist errors
                UIApplication.shared.open(url) { success in
                    print("📱 Native app opened: \(success)")
                    if !success {
                        print("⚠️ Native app failed, opening browser fallback")
                        // If native app fails, open browser as fallback
                        DispatchQueue.main.async {
                            _ = URLSchemeHandler.shared.openInBrowser(url: self.getBrowserURL(platform: platform, query: query))
                        }
                    }
                }
                return true
            }
        }
        
        // Fallback to browser
        print("🌐 Opening browser for \(platform.displayName)")
        
        let browserURL = getBrowserURL(platform: platform, query: query)
        print("🔗 Opening browser URL: \(browserURL)")
        return URLSchemeHandler.shared.openInBrowser(url: browserURL)
    }
    
    private func getBrowserURL(platform: Platform, query: String) -> String {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return "https://www.google.com/search?q=\(query)"
        }
        
        switch platform {
        case .youtube:
            return "https://www.youtube.com/results?search_query=\(encodedQuery)"
        case .reddit:
            return "https://www.reddit.com/search/?q=\(encodedQuery)"
        case .instagram:
            // For Instagram web, default to hashtag search if query starts with #
            if query.hasPrefix("#") {
                let cleanQuery = query.replacingOccurrences(of: "#", with: "")
                return "https://www.instagram.com/explore/tags/\(cleanQuery)/"
            } else {
                return "https://www.instagram.com/explore/search/keyword/?q=\(encodedQuery)"
            }
        case .facebook:
            return "https://www.facebook.com/search/top/?q=\(encodedQuery)"
        case .x:
            return "https://x.com/search?q=\(encodedQuery)&src=typed_query"
        case .tiktok:
            return "https://www.tiktok.com/search?q=\(encodedQuery)"
        }
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
        
        let urlString = "https://www.tiktok.com/search?q=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            print("TikTok Search: Failed to create URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        // Add user agent to avoid being blocked
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        
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
        // Instagram doesn't have a public search API, so we'll create helpful links
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        
        let results = [
            SearchResult(
                title: "#\(query)",
                description: "Search hashtag #\(query) on Instagram",
                url: "https://www.instagram.com/explore/tags/\(query.replacingOccurrences(of: "#", with: ""))/",
                thumbnailURL: nil,
                platform: .instagram,
                type: .post,
                metadata: ["domain": "instagram.com", "query": query, "type": "hashtag"],
                previewContent: "Explore photos and videos tagged with #\(query)",
                directAction: .openInApp
            ),
            SearchResult(
                title: "Search \"\(query)\" on Instagram",
                description: "Find posts, stories, and accounts related to \(query)",
                url: "https://www.instagram.com/explore/search/keyword/?q=\(encodedQuery)",
                thumbnailURL: nil,
                platform: .instagram,
                type: .post,
                metadata: ["domain": "instagram.com", "query": query, "type": "search"],
                previewContent: nil,
                directAction: .openInApp
            ),
            SearchResult(
                title: "\(query) • Instagram",
                description: "Search for accounts named \(query)",
                url: "https://www.instagram.com/\(query.replacingOccurrences(of: " ", with: ""))/",
                thumbnailURL: nil,
                platform: .instagram,
                type: .user,
                metadata: ["domain": "instagram.com", "query": query, "type": "profile"],
                previewContent: nil,
                directAction: .openInApp
            )
        ]
        
        print("Instagram Search: Created \(results.count) helpful search links")
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
                   !title.isEmpty &&
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
                    url: "https://www.tiktok.com/search?q=\(encodedQuery)",
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
                    url: "https://www.tiktok.com/search?q=\(encodedQuery)&t=1",
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