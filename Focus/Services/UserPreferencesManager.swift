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

    func updatePlatformOrderByUsage(_ platformUsage: [String: Int]) {
        // Create a sorted list of platforms based on usage frequency
        let sortedPlatforms = platformUsage.compactMap { (key: String, count: Int) -> (Platform, Int)? in
            guard let platform = Platform(rawValue: key) else { return nil }
            return (platform, count)
        }.sorted { (first: (Platform, Int), second: (Platform, Int)) -> Bool in
            return first.1 > second.1
        }.map { (platformTuple: (Platform, Int)) -> Platform in
            return platformTuple.0
        }

        // Get platforms that haven't been used yet (maintain their original order)
        let unusedPlatforms = Platform.allCases.filter { platform in
            !sortedPlatforms.contains(platform)
        }

        // Combine: most used platforms first, then unused platforms in original order
        preferences.platformOrder = sortedPlatforms + unusedPlatforms
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
    
    // MARK: - Onboarding
    var hasSeenOnboarding: Bool {
        return preferences.hasSeenOnboarding
    }
    
    func setHasSeenOnboarding(_ hasSeen: Bool) {
        preferences.hasSeenOnboarding = hasSeen
    }
    
    // Do Not Disturb functionality removed - not practical on iOS
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

        // Update platform ordering based on actual usage frequency
        UserPreferencesManager.shared.updatePlatformOrderByUsage(analytics.searchesByPlatform)
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
    // No limit on history items - let users keep all their search history
    
    private init() {
        loadSearchHistory()
        // Automatically clean invalid entries on startup
        cleanupInvalidEntries()
    }
    
    private func loadSearchHistory() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let history = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) else {
            return
        }

        // Filter out invalid entries (like 1970 dates or corrupted timestamps)
        let validHistory = history.filter { item in
            // Check if timestamp is reasonable (after 2020)
            let year2020 = Date(timeIntervalSince1970: 1577836800) // Jan 1, 2020
            return item.timestamp >= year2020 && !item.query.isEmpty
        }

        self.searchHistory = validHistory

        // If we filtered out invalid entries, save the cleaned data
        if validHistory.count != history.count {
            saveSearchHistory()
        }
    }
    
    private func saveSearchHistory() {
        if let data = try? JSONEncoder().encode(searchHistory) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func addSearchToHistory(query: String, platform: Platform, resultCount: Int? = nil) {
        let currentTime = Date()
        
        let item = SearchHistoryItem(
            query: query,
            platform: platform,
            timestamp: currentTime,
            resultCount: resultCount
        )
        
        // Add to beginning - keep ALL search history
        searchHistory.insert(item, at: 0)
        
        saveSearchHistory()
        
        // Record analytics for every search
        UsageAnalyticsManager.shared.recordSearch(for: platform)
    }
    
    func clearHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }

    func deleteItem(withId id: UUID) {
        if let index = searchHistory.firstIndex(where: { $0.id == id }) {
            searchHistory.remove(at: index)
            saveSearchHistory()
        }
    }

    func deleteItems(withIds ids: Set<UUID>) {
        searchHistory.removeAll { ids.contains($0.id) }
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

    // MARK: - Auto-cleanup functionality
    func cleanupOldHistory(olderThan days: Int) {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let initialCount = searchHistory.count

        searchHistory.removeAll { $0.timestamp < cutoffDate }

        if searchHistory.count != initialCount {
            saveSearchHistory()
        }
    }

    // Clean invalid entries (like 1970 dates or corrupted data)
    func cleanupInvalidEntries() {
        let initialCount = searchHistory.count
        let year2020 = Date(timeIntervalSince1970: 1577836800) // Jan 1, 2020

        searchHistory.removeAll { item in
            // Remove entries with invalid timestamps or empty queries
            let hasInvalidTimestamp = item.timestamp < year2020
            let hasEmptyQuery = item.query.isEmpty || item.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

            if hasInvalidTimestamp {
                print("Removing item with invalid timestamp: \(item.query) - \(item.timestamp)")
            }

            return hasInvalidTimestamp || hasEmptyQuery
        }

        if searchHistory.count != initialCount {
            saveSearchHistory()
            print("✅ Cleaned \(initialCount - searchHistory.count) invalid search history entries")
        }
    }

    func getHistoryStats() -> (total: Int, today: Int, thisWeek: Int, thisMonth: Int) {
        let calendar = Calendar.current
        let now = Date()

        let total = searchHistory.count
        let today = searchHistory.filter { calendar.isDateInToday($0.timestamp) }.count
        let thisWeek = searchHistory.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .weekOfYear) }.count
        let thisMonth = searchHistory.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .month) }.count

        return (total, today, thisWeek, thisMonth)
    }
}
