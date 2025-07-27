//
//  FocusTests.swift
//  FocusTests
//
//  Created by Wang Dechun on 2025/7/6.
//

import Testing
@testable import Focus

struct FocusTests {

    // MARK: - User Preferences Tests

    @Test func userPreferencesInitialization() async throws {
        let manager = UserPreferencesManager.shared
        #expect(manager.preferences.preferredLanguage == "en")
        #expect(manager.preferences.autoDetectLanguage == true)
        #expect(manager.preferences.enableDoNotDisturb == false)
        #expect(manager.preferences.platformOrder.count == Platform.allCases.count)
    }

    @Test func languageUpdate() async throws {
        let manager = UserPreferencesManager.shared
        manager.updateLanguage("es")
        #expect(manager.preferences.preferredLanguage == "es")
        #expect(manager.preferences.autoDetectLanguage == false)
    }

    @Test func platformOrdering() async throws {
        let manager = UserPreferencesManager.shared
        let originalOrder = manager.preferences.platformOrder
        manager.movePlatformToTop(.reddit)

        #expect(manager.preferences.platformOrder.first == .reddit)
        #expect(manager.preferences.platformOrder != originalOrder)
    }

    // MARK: - Analytics Tests

    @Test func analyticsInitialization() async throws {
        let manager = UsageAnalyticsManager.shared
        #expect(manager.getTotalSearches() >= 0)
        #expect(manager.getTodaysSearches() >= 0)
        #expect(manager.getTimeSaved() >= 0)
    }

    @Test func searchRecording() async throws {
        let manager = UsageAnalyticsManager.shared
        let initialCount = manager.getTotalSearches()

        manager.recordSearch(for: .youtube)

        #expect(manager.getTotalSearches() == initialCount + 1)
        #expect(manager.getTimeSaved() > 0)
    }

    @Test func dailySearchLimits() async throws {
        let analyticsManager = UsageAnalyticsManager.shared
        let preferencesManager = UserPreferencesManager.shared

        // Set a low limit for testing
        preferencesManager.preferences.dailySearchLimit = 2

        // Reset today's count for testing
        let initialCanSearch = analyticsManager.canPerformSearch()
        #expect(initialCanSearch == true || analyticsManager.getRemainingSearches() > 0)
    }

    // MARK: - Search History Tests

    @Test func searchHistoryAddition() async throws {
        let manager = SearchHistoryManager.shared
        let initialCount = manager.searchHistory.count

        manager.addSearchToHistory(query: "SwiftUI Test", platform: .youtube)

        #expect(manager.searchHistory.count == initialCount + 1)
        #expect(manager.searchHistory.first?.query == "SwiftUI Test")
        #expect(manager.searchHistory.first?.platform == .youtube)
    }

    @Test func searchHistoryFiltering() async throws {
        let manager = SearchHistoryManager.shared

        manager.addSearchToHistory(query: "SwiftUI", platform: .youtube)
        manager.addSearchToHistory(query: "iOS", platform: .reddit)

        let youtubeSearches = manager.getSearchesForPlatform(.youtube)
        let redditSearches = manager.getSearchesForPlatform(.reddit)

        #expect(youtubeSearches.count >= 1)
        #expect(redditSearches.count >= 1)
    }

    // MARK: - Premium Features Tests

    @Test func premiumFeatureGating() async throws {
        let manager = PremiumManager.shared

        // Test that premium features require subscription
        let hasInAppBrowsing = manager.isPremiumFeatureAvailable(.inAppBrowsing)
        let hasSearchHistory = manager.isPremiumFeatureAvailable(.searchHistory)
        let hasContentSummary = manager.isPremiumFeatureAvailable(.contentSummary)

        // These should be false for free users or true for premium/trial users
        #expect(hasInAppBrowsing == manager.isPremiumUser || manager.isTrialActive)
        #expect(hasSearchHistory == manager.isPremiumUser || manager.isTrialActive)
        #expect(hasContentSummary == manager.isPremiumUser || manager.isTrialActive)
    }

    // MARK: - Platform Tests

    @Test func platformProperties() async throws {
        for platform in Platform.allCases {
            #expect(!platform.displayName.isEmpty)
            #expect(!platform.searchURL.isEmpty)
            #expect(platform.appScheme != nil)
            #expect(!platform.assetName.isEmpty)
        }
    }

    @Test func platformSearchURLs() async throws {
        let testQuery = "test query"
        let encodedQuery = testQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        for platform in Platform.allCases {
            let searchURL = platform.searchURL + encodedQuery
            #expect(searchURL.hasPrefix("https://"))
            #expect(searchURL.contains(encodedQuery))
        }
    }

    // MARK: - Content Summarization Tests

    @Test func contentSummarizationManager() async throws {
        let manager = ContentSummarizationManager.shared

        #expect(manager.getRemainingCredits() >= 0)
        #expect(manager.getRemainingCredits() <= 50)

        let canUse = manager.canUseSummaryFeature()
        let premiumManager = PremiumManager.shared
        let expectedCanUse = manager.getRemainingCredits() > 0 &&
                           premiumManager.isPremiumFeatureAvailable(.contentSummary)

        #expect(canUse == expectedCanUse)
    }

    // MARK: - Data Model Tests

    @Test func usageAnalyticsCalculations() async throws {
        var analytics = UsageAnalytics()

        analytics.recordSearch(platform: .youtube)
        analytics.recordSearch(platform: .reddit)
        analytics.recordSearch(platform: .youtube)

        #expect(analytics.totalSearches == 3)
        #expect(analytics.searchesByPlatform[Platform.youtube.rawValue] == 2)
        #expect(analytics.searchesByPlatform[Platform.reddit.rawValue] == 1)
        #expect(analytics.getTimeSaved() > 0)
    }

    @Test func userPreferencesSearchMode() async throws {
        var preferences = UserPreferences()

        #expect(preferences.searchMode == .direct)

        preferences.searchMode = .inApp
        #expect(preferences.searchMode == .inApp)
        #expect(preferences.searchMode.displayName == "In-App Browsing")
    }

}
