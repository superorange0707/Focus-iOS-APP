import Foundation

// MARK: - Usage Analytics (Widget Version)
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

    // MARK: - Analytics Methods
    mutating func recordSearch(platform: Platform) {
        totalSearches += 1
        
        let platformKey = platform.rawValue
        searchesByPlatform[platformKey, default: 0] += 1
        
        let today = dateString(from: Date())
        dailySearches[today, default: 0] += 1
        
        // Record time spent (estimated)
        timeSpentOnPlatforms[platformKey, default: 0] += averageTimePerSearch
    }

    func getTodaysSearchCount() -> Int {
        let today = dateString(from: Date())
        return dailySearches[today] ?? 0
    }

    func getTimeSaved() -> TimeInterval {
        return Double(totalSearches) * averageTimePerSearch
    }

    func getTimeSavedToday() -> TimeInterval {
        return Double(getTodaysSearchCount()) * averageTimePerSearch
    }

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// MARK: - Platform Enum (Widget Version)
enum Platform: String, CaseIterable, Codable {
    case youtube = "youtube"
    case google = "google"
    case reddit = "reddit"
    case instagram = "instagram"
    case x = "x"
    case tiktok = "tiktok"
    case facebook = "facebook"
    case bing = "bing"
    
    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .google: return "Google"
        case .reddit: return "Reddit"
        case .instagram: return "Instagram"
        case .x: return "X"
        case .tiktok: return "TikTok"
        case .facebook: return "Facebook"
        case .bing: return "Bing"
        }
    }
    
    var iconName: String {
        return "icon_\(self.rawValue)"
    }
    
    var baseURL: String {
        switch self {
        case .youtube: return "https://www.youtube.com/results?search_query="
        case .google: return "https://www.google.com/search?q="
        case .reddit: return "https://www.reddit.com/search/?q="
        case .instagram: return "https://www.instagram.com/explore/tags/"
        case .x: return "https://twitter.com/search?q="
        case .tiktok: return "https://www.tiktok.com/search?q="
        case .facebook: return "https://www.facebook.com/search/top?q="
        case .bing: return "https://www.bing.com/search?q="
        }
    }
}
