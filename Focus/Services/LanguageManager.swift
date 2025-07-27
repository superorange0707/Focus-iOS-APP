import Foundation
import SwiftUI

// MARK: - Language Manager (for Search URLs only)
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "search_language")
            updatePlatformSearchURLs()
        }
    }

    private let supportedLanguages = [
        "en": "English",
        "es": "Español",
        "fr": "Français",
        "de": "Deutsch",
        "it": "Italiano",
        "pt": "Português",
        "ru": "Русский",
        "ja": "日本語",
        "ko": "한국어",
        "zh": "中文"
    ]

    private init() {
        // Sync with LocalizationManager
        self.currentLanguage = LocalizationManager.shared.currentLanguage

        // Listen for localization changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localizationChanged),
            name: .localizationChanged,
            object: nil
        )
    }

    @objc private func localizationChanged(_ notification: Notification) {
        if let newLanguage = notification.object as? String {
            currentLanguage = newLanguage
        }
    }
    
    // MARK: - Public Methods
    
    func getSupportedLanguages() -> [(code: String, name: String)] {
        return supportedLanguages.map { (code: $0.key, name: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func getLanguageName(for code: String) -> String {
        return supportedLanguages[code] ?? "Unknown"
    }
    
    func setLanguage(_ languageCode: String) {
        guard supportedLanguages.keys.contains(languageCode) else { return }
        currentLanguage = languageCode
    }
    
    func getSystemLanguage() -> String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }
    
    // MARK: - Platform URL Localization
    
    private func updatePlatformSearchURLs() {
        // This will trigger UI updates that use localized URLs
        NotificationCenter.default.post(name: .languageChanged, object: currentLanguage)
    }
    
    func getLocalizedSearchURL(for platform: Platform, query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        switch platform {
        case .youtube:
            return getYouTubeURL(query: encodedQuery)
        case .reddit:
            return getRedditURL(query: encodedQuery)
        case .x:
            return getXURL(query: encodedQuery)
        case .tiktok:
            return getTikTokURL(query: encodedQuery)
        case .instagram:
            return getInstagramURL(query: encodedQuery)
        case .facebook:
            return getFacebookURL(query: encodedQuery)
        }
    }
    
    // MARK: - Platform-Specific URL Generation
    
    private func getYouTubeURL(query: String) -> String {
        let baseURL = "https://www.youtube.com/results?search_query="
        let languageParam = "&hl=\(currentLanguage)"
        return baseURL + query + languageParam
    }
    
    private func getRedditURL(query: String) -> String {
        // Reddit doesn't have direct language support, but we can suggest localized subreddits
        let baseURL = "https://www.reddit.com/search/?q="
        return baseURL + query
    }
    
    private func getXURL(query: String) -> String {
        let baseURL = "https://twitter.com/search?q="
        let languageParam = "&lang=\(currentLanguage)"
        return baseURL + query + languageParam
    }
    
    private func getTikTokURL(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // TikTok browser search - simple format that works in Safari
        if query.hasPrefix("#") {
            let cleanQuery = query.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: " ", with: "")
            return "https://www.tiktok.com/tag/\(cleanQuery)"
        } else if query.hasPrefix("@") {
            let cleanQuery = query.replacingOccurrences(of: "@", with: "")
            return "https://www.tiktok.com/@\(cleanQuery)"
        } else {
            // Use standard TikTok search URL that works in browser
            return "https://www.tiktok.com/search?q=\(encodedQuery)"
        }
    }
    
    private func getInstagramURL(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // Instagram web search - use keyword search format that works best
        if query.hasPrefix("@") {
            let cleanQuery = query.replacingOccurrences(of: "@", with: "")
            return "https://www.instagram.com/\(cleanQuery)/"
        } else {
            // Use keyword search format - shows both accounts and posts
            return "https://www.instagram.com/explore/search/keyword/?q=\(encodedQuery)"
        }
    }
    
    private func getFacebookURL(query: String) -> String {
        let baseURL = "https://www.facebook.com/search/top?q="
        return baseURL + query
    }
    

}

// MARK: - Notification Extension
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
    static let localizationChanged = Notification.Name("localizationChanged")
}

// MARK: - SwiftUI Environment Key
struct LanguageManagerKey: EnvironmentKey {
    static let defaultValue = LanguageManager.shared
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageManagerKey.self] }
        set { self[LanguageManagerKey.self] = newValue }
    }
}
