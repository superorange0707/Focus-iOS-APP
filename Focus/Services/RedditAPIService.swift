import Foundation
import SwiftUI

// MARK: - Reddit API Service
class RedditAPIService: ObservableObject {
    static let shared = RedditAPIService()
    
    private let baseURL = "https://www.reddit.com"
    private let session = URLSession.shared
    
    @Published var posts: [RedditPost] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private init() {}
    
    func searchPosts(query: String, subreddit: String? = nil, sort: RedditSort = .relevance, timeFilter: RedditTimeFilter = .all) async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let searchResults = try await performSearch(query: query, subreddit: subreddit, sort: sort, timeFilter: timeFilter)
            
            await MainActor.run {
                self.posts = searchResults
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func performSearch(query: String, subreddit: String?, sort: RedditSort, timeFilter: RedditTimeFilter) async throws -> [RedditPost] {
        var urlString = "\(baseURL)/search.json"
        var queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "t", value: timeFilter.rawValue),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "raw_json", value: "1")
        ]
        
        if let subreddit = subreddit {
            queryItems.append(URLQueryItem(name: "restrict_sr", value: "1"))
            urlString = "\(baseURL)/r/\(subreddit)/search.json"
        }
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw RedditAPIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw RedditAPIError.networkError
        }
        
        let redditResponse = try JSONDecoder().decode(RedditResponse.self, from: data)
        return redditResponse.data.children.map { $0.data }
    }
}

// MARK: - Reddit Data Models
struct RedditResponse: Codable {
    let data: RedditListing
}

struct RedditListing: Codable {
    let children: [RedditChild]
}

struct RedditChild: Codable {
    let data: RedditPost
}

struct RedditPost: Codable, Identifiable {
    let id: String
    let title: String
    let author: String
    let subreddit: String
    let score: Int
    let numComments: Int
    let created: Double
    let url: String
    let permalink: String
    let selftext: String?
    let thumbnail: String?
    let preview: RedditPreview?
    let isVideo: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, author, subreddit, score, url, permalink, selftext, thumbnail, preview
        case numComments = "num_comments"
        case created = "created_utc"
        case isVideo = "is_video"
    }
    
    var redditURL: String {
        return "https://www.reddit.com\(permalink)"
    }
    
    var createdDate: Date {
        return Date(timeIntervalSince1970: created)
    }
    
    var thumbnailURL: URL? {
        guard let thumbnail = thumbnail,
              thumbnail != "self",
              thumbnail != "default",
              thumbnail != "nsfw",
              thumbnail != "spoiler",
              let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }
    
    var previewImageURL: URL? {
        guard let preview = preview,
              let source = preview.images.first?.source,
              let url = URL(string: source.url.replacingOccurrences(of: "&amp;", with: "&")) else {
            return nil
        }
        return url
    }
}

struct RedditPreview: Codable {
    let images: [RedditImage]
}

struct RedditImage: Codable {
    let source: RedditImageSource
}

struct RedditImageSource: Codable {
    let url: String
    let width: Int
    let height: Int
}

// MARK: - Reddit Enums
enum RedditSort: String, CaseIterable {
    case relevance = "relevance"
    case hot = "hot"
    case top = "top"
    case new = "new"
    case comments = "comments"
    
    var displayName: String {
        switch self {
        case .relevance: return "Relevance"
        case .hot: return "Hot"
        case .top: return "Top"
        case .new: return "New"
        case .comments: return "Comments"
        }
    }
}

enum RedditTimeFilter: String, CaseIterable {
    case all = "all"
    case year = "year"
    case month = "month"
    case week = "week"
    case day = "day"
    case hour = "hour"
    
    var displayName: String {
        switch self {
        case .all: return "All Time"
        case .year: return "Past Year"
        case .month: return "Past Month"
        case .week: return "Past Week"
        case .day: return "Past Day"
        case .hour: return "Past Hour"
        }
    }
}

enum RedditAPIError: Error, LocalizedError {
    case invalidURL
    case networkError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError:
            return "Network error occurred"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
