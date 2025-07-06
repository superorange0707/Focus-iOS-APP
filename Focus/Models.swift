import Foundation
import SwiftUI

// Platform enum
enum Platform: String, CaseIterable {
    case youtube = "youtube"
    case reddit = "reddit"
    case instagram = "instagram"
    case facebook = "facebook"
    case x = "x"
    case google = "google"
    case bing = "bing"
    
    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .reddit: return "Reddit"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .x: return "X"
        case .google: return "Google"
        case .bing: return "Bing"
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
        case .google: return "icon_google"
        case .bing: return "icon_bing"
        }
    }
    
    var icon: String {
        switch self {
        case .youtube: return "play.rectangle.fill"
        case .reddit: return "bubble.left.and.bubble.right.fill"
        case .instagram: return "camera.fill"
        case .facebook: return "person.2.fill"
        case .x: return "xmark"
        case .google: return "globe"
        case .bing: return "magnifyingglass"
        }
    }
    
    var color: Color {
        switch self {
        case .youtube: return Color(red: 0.95, green: 0.13, blue: 0.13)
        case .reddit: return Color.orange
        case .instagram: return Color.purple
        case .facebook: return Color(red: 0.23, green: 0.35, blue: 0.60)
        case .x: return Color(red: 0.13, green: 0.13, blue: 0.18)
        case .google: return Color(red: 0.0, green: 0.48, blue: 1.0)
        case .bing: return Color(red: 0.0, green: 0.48, blue: 1.0)
        }
    }
    
    var searchURL: String {
        switch self {
        case .youtube: return "https://www.youtube.com/results?search_query="
        case .reddit: return "https://www.reddit.com/search/?q="
        case .instagram: return "https://www.instagram.com/explore/tags/"
        case .facebook: return "https://www.facebook.com/search/top/?q="
        case .x: return "https://x.com/search?q="
        case .google: return "https://www.google.com/search?q="
        case .bing: return "https://www.bing.com/search?q="
        }
    }
    
    var appScheme: String? {
        switch self {
        case .youtube: return "youtube://"
        case .reddit: return "reddit://"
        case .instagram: return "instagram://"
        case .facebook: return "fb://"
        case .x: return "x://"
        case .google: return "google://"
        case .bing: return "bing://"
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
struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let thumbnailURL: String?
    let platform: Platform
    let type: ResultType
    let metadata: [String: String]
    let previewContent: String?
    let directAction: DirectAction?
    
    enum ResultType {
        case video
        case post
        case article
        case image
        case user
        case website
        case news
        case product
    }
    
    enum DirectAction {
        case openInApp
        case openInBrowser
        case share
        case bookmark
    }
}

// MARK: - YouTube API Models
struct YouTubeSearchResponse: Codable {
    let items: [YouTubeSearchItem]
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
    
    private let youtubeAPIKey = "AIzaSyAaG-amyCVK7-N4ahsZAfJ0mq-CyZdcyKc"
    
    private init() {
        loadRecentSearches()
        loadPopularSearches()
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
                "\(query) instagram",
                "\(query) photos",
                "\(query) stories"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        default:
            return []
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
        default:
            return []
        }
    }
    
    func searchYouTube(query: String, completion: @escaping ([SearchResult]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=\(encodedQuery)&key=\(youtubeAPIKey)"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            do {
                let decoded = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                let results: [SearchResult] = decoded.items.compactMap { item in
                    guard let videoId = item.id.videoId else { return nil }
                    return SearchResult(
                        title: item.snippet.title,
                        description: item.snippet.description,
                        url: "https://www.youtube.com/watch?v=\(videoId)",
                        thumbnailURL: item.snippet.thumbnails.high?.url ?? item.snippet.thumbnails.medium?.url,
                        platform: .youtube,
                        type: .video,
                        metadata: [
                            "channel": item.snippet.channelTitle,
                            "published": item.snippet.publishedAt
                        ],
                        previewContent: nil,
                        directAction: .openInApp
                    )
                }
                completion(results)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
    
    func search(query: String, platform: Platform, completion: @escaping ([SearchResult]) -> Void) {
        addToRecentSearches(query)
        switch platform {
        case .youtube:
            searchYouTube(query: query, completion: completion)
        default:
            // fallback to mock for now
            completion([
                SearchResult(
                    title: "Sample \(platform.displayName) Result",
                    description: "This is a sample result for \(platform.displayName) search with enhanced metadata and preview content.",
                    url: "https://\(platform.rawValue).com/sample",
                    thumbnailURL: nil,
                    platform: platform,
                    type: .website,
                    metadata: ["domain": "\(platform.rawValue).com"],
                    previewContent: "Sample preview content for \(platform.displayName) search results.",
                    directAction: .openInBrowser
                )
            ])
        }
    }
    
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
    
    func searchX(query: String, completion: @escaping ([SearchResult]) -> Void) {
        completion([
            SearchResult(
                title: "Sample X Result",
                description: "This is a sample result for X search.",
                url: "https://x.com/sample",
                thumbnailURL: nil,
                platform: .x,
                type: .post,
                metadata: ["user": "@sample"],
                previewContent: nil,
                directAction: .openInApp
            )
        ])
    }
    
    func searchReddit(query: String, completion: @escaping ([SearchResult]) -> Void) {
        completion([
            SearchResult(
                title: "Sample Reddit Result",
                description: "This is a sample result for Reddit search.",
                url: "https://reddit.com/sample",
                thumbnailURL: nil,
                platform: .reddit,
                type: .post,
                metadata: ["subreddit": "r/sample"],
                previewContent: nil,
                directAction: .openInApp
            )
        ])
    }
    
    func searchGoogle(query: String, completion: @escaping ([SearchResult]) -> Void) {
        completion([
            SearchResult(
                title: "Sample Google Result",
                description: "This is a sample result for Google search.",
                url: "https://google.com/sample",
                thumbnailURL: nil,
                platform: .google,
                type: .website,
                metadata: ["domain": "google.com"],
                previewContent: nil,
                directAction: .openInBrowser
            )
        ])
    }
    
    func searchBing(query: String, completion: @escaping ([SearchResult]) -> Void) {
        completion([
            SearchResult(
                title: "Sample Bing Result",
                description: "This is a sample result for Bing search.",
                url: "https://bing.com/sample",
                thumbnailURL: nil,
                platform: .bing,
                type: .website,
                metadata: ["domain": "bing.com"],
                previewContent: nil,
                directAction: .openInBrowser
            )
        ])
    }
} 