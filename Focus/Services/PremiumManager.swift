import Foundation
import StoreKit
import SwiftUI

// MARK: - Premium Manager
@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremiumUser: Bool = false
    @Published var isTrialActive: Bool = false
    @Published var trialDaysRemaining: Int = 0
    @Published var availableProducts: [Product] = []
    @Published var purchasedProducts: [Product] = []
    
    private let trialDuration: TimeInterval = 3 * 24 * 60 * 60 // 3 days
    private let trialStartKey = "trial_start_date"
    
    // Product IDs - update these with your actual App Store Connect product IDs
    private let productIDs = [
        "com.focus.premium.monthly",
        "com.focus.premium.yearly",
        "com.focus.premium.lifetime"
    ]
    
    private init() {
        checkTrialStatus()
        checkPremiumStatus()
    }
    
    // MARK: - Trial Management
    func startTrial() {
        guard !hasTrialStarted() else { return }
        
        UserDefaults.standard.set(Date(), forKey: trialStartKey)
        isTrialActive = true
        updateTrialDaysRemaining()
    }
    
    private func hasTrialStarted() -> Bool {
        return UserDefaults.standard.object(forKey: trialStartKey) != nil
    }
    
    private func checkTrialStatus() {
        guard let trialStartDate = UserDefaults.standard.object(forKey: trialStartKey) as? Date else {
            isTrialActive = false
            trialDaysRemaining = 3
            return
        }
        
        let timeElapsed = Date().timeIntervalSince(trialStartDate)
        let isActive = timeElapsed < trialDuration && !isPremiumUser
        
        isTrialActive = isActive
        updateTrialDaysRemaining()
    }
    
    private func updateTrialDaysRemaining() {
        guard let trialStartDate = UserDefaults.standard.object(forKey: trialStartKey) as? Date else {
            trialDaysRemaining = 3
            return
        }
        
        let timeElapsed = Date().timeIntervalSince(trialStartDate)
        let daysElapsed = Int(timeElapsed / (24 * 60 * 60))
        trialDaysRemaining = max(0, 3 - daysElapsed)
    }
    
    // MARK: - Premium Status
    private func checkPremiumStatus() {
        // Check for active subscriptions or lifetime purchase
        Task {
            await loadProducts()
            await checkPurchasedProducts()
        }
    }
    
    func isPremiumFeatureAvailable(_ feature: PremiumFeature) -> Bool {
        return isPremiumUser || isTrialActive
    }
    
    // MARK: - StoreKit Integration
    func loadProducts() async {
        do {
            let products = try await Product.products(for: productIDs)
            await MainActor.run {
                self.availableProducts = products.sorted { product1, product2 in
                    // Sort by price: monthly, yearly, lifetime
                    if product1.id.contains("monthly") { return true }
                    if product2.id.contains("monthly") { return false }
                    if product1.id.contains("yearly") { return true }
                    if product2.id.contains("yearly") { return false }
                    return false
                }
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await MainActor.run {
                    self.isPremiumUser = true
                }
                await transaction.finish()
            case .unverified:
                throw PremiumError.verificationFailed
            }
        case .userCancelled:
            throw PremiumError.userCancelled
        case .pending:
            throw PremiumError.pending
        @unknown default:
            throw PremiumError.unknown
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkPurchasedProducts()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    private func checkPurchasedProducts() async {
        var hasPremium = false
        
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if productIDs.contains(transaction.productID) {
                    hasPremium = true
                }
            case .unverified:
                break
            }
        }
        
        await MainActor.run {
            self.isPremiumUser = hasPremium
        }
    }
    
    // MARK: - Product Information
    func getProductDisplayName(_ product: Product) -> String {
        if product.id.contains("monthly") {
            return "Monthly Subscription"
        } else if product.id.contains("yearly") {
            return "Yearly Subscription"
        } else if product.id.contains("lifetime") {
            return "Lifetime Purchase"
        }
        return product.displayName
    }
    
    func getProductDescription(_ product: Product) -> String {
        if product.id.contains("monthly") {
            return "Full access to all premium features, billed monthly"
        } else if product.id.contains("yearly") {
            return "Full access to all premium features, billed yearly (save 40%)"
        } else if product.id.contains("lifetime") {
            return "One-time purchase for lifetime access to all premium features"
        }
        return product.description
    }
    
    func getProductPrice(_ product: Product) -> String {
        return product.displayPrice
    }
    
    // MARK: - Feature Gating
    func requiresPremium(for feature: PremiumFeature) -> Bool {
        return !isPremiumFeatureAvailable(feature)
    }
    
    func showPremiumUpgradeIfNeeded(for feature: PremiumFeature) -> Bool {
        if requiresPremium(for: feature) {
            // This would trigger showing the premium upgrade screen
            return true
        }
        return false
    }
}

// MARK: - Premium Errors
enum PremiumError: Error, LocalizedError {
    case verificationFailed
    case userCancelled
    case pending
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .verificationFailed:
            return "Purchase verification failed"
        case .userCancelled:
            return "Purchase was cancelled"
        case .pending:
            return "Purchase is pending"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Do Not Disturb Manager
class DoNotDisturbManager: ObservableObject {
    static let shared = DoNotDisturbManager()
    
    private init() {}
    
    func enableDoNotDisturb() {
        // Note: iOS doesn't allow apps to directly control Do Not Disturb
        // This would need to guide users to enable it manually or use Focus modes
        // For now, we'll implement a notification to remind users
        
        if UserPreferencesManager.shared.isDoNotDisturbEnabled() {
            showDoNotDisturbReminder()
        }
    }
    
    private func showDoNotDisturbReminder() {
        // Show a notification or alert reminding users to enable Do Not Disturb
        // This could be implemented as a banner or modal
        print("Reminder: Enable Do Not Disturb for focused searching")
    }
    
    func scheduleDoNotDisturbReminder() {
        // Schedule a local notification to remind users about Do Not Disturb
        // This would be implemented with UNUserNotificationCenter
    }
}
