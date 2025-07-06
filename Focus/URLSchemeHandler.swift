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
        .google: ["google://", "google://www.google.com/", "google://google.com/"],
        .bing: ["bing://", "bing://www.bing.com/", "bing://bing.com/"]
    ]
    
    // App Store IDs for fallback
    private let appStoreIDs: [Platform: String] = [
        .youtube: "544007664",
        .reddit: "1064216828",
        .instagram: "389801252",
        .facebook: "284882215",
        .x: "333903271",
        .google: "284815942",
        .bing: "345323231"
    ]
    
    func openInNativeApp(platform: Platform, url: String) -> Bool {
        // Try to open in native app first
        if let schemes = urlSchemes[platform] {
            for scheme in schemes {
                let appURL = scheme + url.replacingOccurrences(of: "https://", with: "")
                if let url = URL(string: appURL), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    return true
                }
            }
        }
        
        // If native app is not available, open in browser
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
        guard let schemes = urlSchemes[platform] else { return false }
        
        for scheme in schemes {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
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
            return "https://www.instagram.com/explore/tags/\(query.replacingOccurrences(of: "#", with: "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .facebook:
            return "https://www.facebook.com/search/top/?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .x:
            return "https://www.x.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .google:
            return "https://www.google.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .bing:
            return "https://www.bing.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        }
    }
    
    func formatNativeAppURL(for platform: Platform, query: String) -> String? {
        switch platform {
        case .youtube:
            return "youtube://www.youtube.com/results?search_query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .reddit:
            return "reddit://www.reddit.com/search/?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .instagram:
            return "instagram://www.instagram.com/explore/tags/\(query.replacingOccurrences(of: "#", with: "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .facebook:
            return "fb://www.facebook.com/search/top/?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .x:
            return "x://www.x.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .google:
            return "google://www.google.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        case .bing:
            return "bing://www.bing.com/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        }
    }
} 