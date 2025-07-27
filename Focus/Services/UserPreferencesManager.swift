import Foundation
import SwiftUI

// MARK: - User Preferences Manager
class UserPreferencesManager: ObservableObject {
    static let shared = UserPreferencesManager()
    
    @Published var preferences: UserPreferences {
        didSet {
            savePreferences()
        }
    }
    
    private let userDefaultsKey = "user_preferences"
    
    private init() {
        self.preferences = UserPreferencesManager.loadPreferences()
    }
    
    private static func loadPreferences() -> UserPreferences {
        guard let data = UserDefaults.standard.data(forKey: "user_preferences"),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return UserPreferences()
        }
        return preferences
    }
    
    private func savePreferences() {
        if let data = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    // MARK: - Platform Ordering
    func updatePlatformOrder(based platforms: [Platform]) {
        preferences.platformOrder = platforms
    }
    
    func getOrderedPlatforms() -> [Platform] {
        return preferences.platformOrder
    }
    
    func movePlatformToTop(_ platform: Platform) {
        var newOrder = preferences.platformOrder.filter { $0 != platform }
        newOrder.insert(platform, at: 0)
        preferences.platformOrder = newOrder
    }
    
    // MARK: - Language Settings
    func updateLanguage(_ languageCode: String) {
        preferences.preferredLanguage = languageCode
        preferences.autoDetectLanguage = false

        // Update LocalizationManager and LanguageManager
        LocalizationManager.shared.setLanguage(languageCode)
        LanguageManager.shared.setLanguage(languageCode)
    }

    func setAutoDetectLanguage(_ enabled: Bool) {
        preferences.autoDetectLanguage = enabled

        if enabled {
            // Switch to system language
            let systemLanguage = LocalizationManager.shared.getSystemLanguage()
            LocalizationManager.shared.setLanguage(systemLanguage)
            LanguageManager.shared.setLanguage(systemLanguage)
        }
    }

    func getPreferredLanguage() -> String {
        if preferences.autoDetectLanguage {
            return LocalizationManager.shared.getSystemLanguage()
        }
        return preferences.preferredLanguage
    }
    
    // MARK: - Search Mode
    func setSearchMode(_ mode: UserPreferences.SearchMode) {
        preferences.searchMode = mode
    }
    
    func getSearchMode() -> UserPreferences.SearchMode {
        return preferences.searchMode
    }
    
    // MARK: - Do Not Disturb
    func setDoNotDisturbEnabled(_ enabled: Bool) {
        preferences.enableDoNotDisturb = enabled
    }
    
    func isDoNotDisturbEnabled() -> Bool {
        return preferences.enableDoNotDisturb
    }
}

// MARK: - Usage Analytics Manager
class UsageAnalyticsManager: ObservableObject {
    static let shared = UsageAnalyticsManager()
    
    @Published var analytics: UsageAnalytics {
        didSet {
            saveAnalytics()
        }
    }
    
    private let userDefaultsKey = "usage_analytics"
    
    private init() {
        self.analytics = UsageAnalyticsManager.loadAnalytics()
    }
    
    private static func loadAnalytics() -> UsageAnalytics {
        guard let data = UserDefaults.standard.data(forKey: "usage_analytics"),
              let analytics = try? JSONDecoder().decode(UsageAnalytics.self, from: data) else {
            return UsageAnalytics()
        }
        return analytics
    }
    
    private func saveAnalytics() {
        if let data = try? JSONEncoder().encode(analytics) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)

            // Also save to shared UserDefaults for widget access
            if let sharedDefaults = UserDefaults(suiteName: "group.com.focus.app") {
                sharedDefaults.set(data, forKey: "usage_analytics")
            }
        }
    }
    
    // MARK: - Search Tracking
    func recordSearch(for platform: Platform) {
        analytics.recordSearch(platform: platform)
        
        // Update platform ordering based on usage
        UserPreferencesManager.shared.movePlatformToTop(platform)
    }
    
    func getTotalSearches() -> Int {
        return analytics.totalSearches
    }
    
    func getTodaysSearches() -> Int {
        return analytics.getTodaysSearchCount()
    }
    
    func getTimeSaved() -> TimeInterval {
        return analytics.getTimeSaved()
    }
    
    func getTimeSavedToday() -> TimeInterval {
        return analytics.getTimeSavedToday()
    }
    
    func getMostUsedPlatforms() -> [(Platform, Int)] {
        return analytics.searchesByPlatform.compactMap { key, value in
            guard let platform = Platform(rawValue: key) else { return nil }
            return (platform, value)
        }.sorted { $0.1 > $1.1 }
    }
    
    // MARK: - Daily Limits
    func canPerformSearch() -> Bool {
        let todaySearches = getTodaysSearches()
        let limit = UserPreferencesManager.shared.preferences.dailySearchLimit
        return todaySearches < limit
    }
    
    func getRemainingSearches() -> Int {
        let todaySearches = getTodaysSearches()
        let limit = UserPreferencesManager.shared.preferences.dailySearchLimit
        return max(0, limit - todaySearches)
    }

    // MARK: - Search History Integration
    func getRecentSearchHistory(limit: Int = 20) -> [SearchHistoryItem] {
        return SearchHistoryManager.shared.getRecentSearches(limit: limit)
    }
}

// MARK: - Search History Manager
class SearchHistoryManager: ObservableObject {
    static let shared = SearchHistoryManager()
    
    @Published var searchHistory: [SearchHistoryItem] = []
    
    private let userDefaultsKey = "search_history"
    private let maxHistoryItems = 100
    
    private init() {
        loadSearchHistory()
    }
    
    private func loadSearchHistory() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let history = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) else {
            return
        }
        self.searchHistory = history
    }
    
    private func saveSearchHistory() {
        if let data = try? JSONEncoder().encode(searchHistory) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func addSearchToHistory(query: String, platform: Platform, resultCount: Int? = nil) {
        let item = SearchHistoryItem(
            query: query,
            platform: platform,
            timestamp: Date(),
            resultCount: resultCount
        )
        
        // Remove duplicate if exists
        searchHistory.removeAll { $0.query == query && $0.platform == platform }
        
        // Add to beginning
        searchHistory.insert(item, at: 0)
        
        // Limit history size
        if searchHistory.count > maxHistoryItems {
            searchHistory = Array(searchHistory.prefix(maxHistoryItems))
        }
        
        saveSearchHistory()
    }
    
    func clearHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }
    
    func getRecentSearches(limit: Int = 10) -> [SearchHistoryItem] {
        return Array(searchHistory.prefix(limit))
    }
    
    func getSearchesForPlatform(_ platform: Platform, limit: Int = 5) -> [SearchHistoryItem] {
        return searchHistory
            .filter { $0.platform == platform }
            .prefix(limit)
            .map { $0 }
    }
}
