import Foundation
import UIKit

class URLSchemeHandler {
    static let shared = URLSchemeHandler()
    
    private init() {}
    
    // URL schemes for different platforms
    private let urlSchemes: [Platform: [String]] = [
        .youtube: ["youtube://", "youtube://www.youtube.com/", "youtube://youtube.com/"],
        .reddit: ["reddit://", "reddit://www.reddit.com/", "reddit://reddit.com/"],
        .instagram: ["instagram://", "instagram://www.instagram.com/", "instagram://instagram.com/"],
        .facebook: ["fb://", "facebook://", "fb://www.facebook.com/", "facebook://www.facebook.com/"],
        .x: ["x://", "x://www.x.com/", "x://x.com/"],
        .tiktok: ["tiktok://", "tiktok://www.tiktok.com/", "tiktok://tiktok.com/"]
    ]
    
    // App Store IDs for fallback
    private let appStoreIDs: [Platform: String] = [
        .youtube: "544007664",
        .reddit: "1064216828",
        .instagram: "389801252",
        .facebook: "284882215",
        .x: "333903271",
        .tiktok: "835599320"
    ]
    
    func openInNativeApp(platform: Platform, url: String) -> Bool {
        // Simplified for free tier - try to open native app directly without checking
        // This avoids UIApplication.canOpenURL calls that cause eligibility_plist errors
        
        if let schemes = urlSchemes[platform], let firstScheme = schemes.first {
            let appURL = firstScheme + url.replacingOccurrences(of: "https://", with: "")
            if let url = URL(string: appURL) {
                UIApplication.shared.open(url) { success in
                    if !success {
                        // If native app fails, open in browser as fallback
                        _ = self.openInBrowser(url: url.absoluteString)
                    }
                }
                return true
            }
        }
        
        // Fallback to browser
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
            return true
        }
        
        return false
    }
    
    func openInBrowser(url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        UIApplication.shared.open(url)
        return true
    }
    
    func openAppStore(platform: Platform) -> Bool {
        guard let appStoreID = appStoreIDs[platform] else { return false }
        let appStoreURL = "https://apps.apple.com/app/id\(appStoreID)"
        return openInBrowser(url: appStoreURL)
    }
    
    func canOpenNativeApp(platform: Platform) -> Bool {
        // Check if we're running in simulator - apps usually aren't installed there
        #if targetEnvironment(simulator)
        return false  // Simulator typically doesn't have these apps installed
        #else
        // On real devices, try native apps for ALL platforms with creative workarounds
        switch platform {
        case .youtube:
            return true  // YouTube app supports search URLs
        case .instagram:
            return true  // Instagram app supports hashtag/user searches + clipboard workaround for general search
        case .x:
            return true  // X/Twitter app supports search URLs
        case .reddit:
            return true  // Reddit app supports search URLs
        case .facebook:
            return true  // Facebook app opens + clipboard workaround for search
        case .tiktok:
            return false  // Always use web-to-app redirect strategy for TikTok search
        }
        #endif
    }
    
    func getPreferredAction(for platform: Platform) -> PreferredAction {
        if canOpenNativeApp(platform: platform) {
            return .nativeApp
        } else {
            return .browser
        }
    }
    
    enum PreferredAction {
        case nativeApp
        case browser
        case appStore
    }
}

// Extension to handle specific platform URL formatting
extension URLSchemeHandler {
    func formatURL(for platform: Platform, query: String) -> String {
        switch platform {
        case .youtube:
            return "https://www.youtube.com/results?search_query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .reddit:
            return "https://www.reddit.com/search/?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .instagram:
            // Use general search format that works for all types of content
            if query.hasPrefix("#") {
                // For hashtag searches, use the hashtag URL format
                let cleanQuery = query.replacingOccurrences(of: "#", with: "")
                return "https://www.instagram.com/explore/tags/\(cleanQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cleanQuery)/"
            } else if query.hasPrefix("@") {
                // For user searches, go directly to user profile
                let cleanQuery = query.replacingOccurrences(of: "@", with: "")
                return "https://www.instagram.com/\(cleanQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cleanQuery)/"
            } else {
                // For general searches, use Google search for Instagram content since Instagram blocks direct search URLs
                return "https://www.google.com/search?q=site:instagram.com+\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
            }
        case .facebook:
            return "https://www.facebook.com/search/top/?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .x:
            return "https://www.x.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .tiktok:
            // TikTok: Always open main search page for single input experience
            // Let users input their search query directly in TikTok WebView
            return "https://www.tiktok.com/search"
        }
    }
    
    func formatNativeAppURL(for platform: Platform, query: String) -> String? {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        switch platform {
        case .youtube:
            return "youtube://www.youtube.com/results?search_query=\(encodedQuery)"
        case .reddit:
            return "reddit://www.reddit.com/search/?q=\(encodedQuery)"
        case .instagram:
            // Instagram only supports hashtags and users in native app
            if query.hasPrefix("#") {
                let cleanQuery = query.replacingOccurrences(of: "#", with: "")
                return "instagram://tag?name=\(cleanQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cleanQuery)"
            } else if !query.contains(" ") && query.count > 2 {
                return "instagram://user?username=\(query)"
            } else {
                return nil // Use browser for general searches
            }
        case .facebook:
            return nil // Facebook app doesn't support search URLs
        case .x:
            return "twitter://search?query=\(encodedQuery)"
        case .tiktok:
            // TikTok app doesn't support search URL schemes - always use web-to-app redirect strategy
            return nil
        }
    }
} 