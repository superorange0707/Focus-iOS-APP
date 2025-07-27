import SwiftUI
import StoreKit

// MARK: - Premium Upgrade View
struct PremiumUpgradeView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Upgrade to Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Unlock powerful features for focused searching")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Trial info
                    if !premiumManager.isTrialActive && !premiumManager.isPremiumUser {
                        TrialOfferCard()
                    } else if premiumManager.isTrialActive {
                        TrialStatusCard()
                    }
                    
                    // Features list
                    VStack(spacing: 16) {
                        Text("Premium Features")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(PremiumFeature.allCases, id: \.self) { feature in
                            PremiumFeatureRow(feature: feature)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Products
                    if !premiumManager.availableProducts.isEmpty {
                        VStack(spacing: 16) {
                            Text("Choose Your Plan")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ForEach(premiumManager.availableProducts, id: \.id) { product in
                                ProductCard(
                                    product: product,
                                    isSelected: selectedProduct?.id == product.id,
                                    onSelect: { selectedProduct = product }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Purchase button
                    if let selectedProduct = selectedProduct {
                        Button(action: {
                            purchaseProduct(selectedProduct)
                        }) {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "crown.fill")
                                }
                                
                                Text(isPurchasing ? "Processing..." : "Start Premium")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.focusBlue)
                            .cornerRadius(16)
                        }
                        .disabled(isPurchasing)
                        .padding(.horizontal)
                    }
                    
                    // Restore purchases
                    Button("Restore Purchases") {
                        restorePurchases()
                    }
                    .font(.subheadline)
                    .foregroundColor(.focusBlue)
                    
                    // Terms and privacy
                    VStack(spacing: 8) {
                        Text("By purchasing, you agree to our Terms of Service and Privacy Policy")
                            .font(.caption)
                            .foregroundColor(.tertiaryText)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            Button("Terms of Service") {
                                // Open terms
                            }
                            .font(.caption)
                            .foregroundColor(.focusBlue)
                            
                            Button("Privacy Policy") {
                                // Open privacy policy
                            }
                            .font(.caption)
                            .foregroundColor(.focusBlue)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await premiumManager.loadProducts()
            if !premiumManager.availableProducts.isEmpty {
                selectedProduct = premiumManager.availableProducts.first
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func purchaseProduct(_ product: Product) {
        isPurchasing = true
        
        Task {
            do {
                try await premiumManager.purchase(product)
                await MainActor.run {
                    isPurchasing = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
    
    private func restorePurchases() {
        Task {
            await premiumManager.restorePurchases()
        }
    }
}

// MARK: - Trial Offer Card
struct TrialOfferCard: View {
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "gift.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("3-Day Free Trial")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Text("Try all premium features free for 3 days. Cancel anytime.")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
            
            Button("Start Free Trial") {
                premiumManager.startTrial()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.green)
            .cornerRadius(12)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Trial Status Card
struct TrialStatusCard: View {
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.orange)
                    .font(.title2)
                
                Text("Trial Active")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(premiumManager.trialDaysRemaining) days left")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
            
            Text("Enjoying premium features? Upgrade now to continue after your trial ends.")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Premium Feature Row
struct PremiumFeatureRow: View {
    let feature: PremiumFeature
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: featureIcon)
                .font(.title3)
                .foregroundColor(.focusBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(feature.description)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    private var featureIcon: String {
        switch feature {
        case .inAppBrowsing: return "safari"
        case .searchHistory: return "clock.arrow.circlepath"
        case .doNotDisturb: return "moon.fill"
        case .advancedSearch: return "slider.horizontal.3"
        case .contentSummary: return "doc.text.magnifyingglass"
        case .unlimitedSearches: return "infinity"
        }
    }
}

// MARK: - Product Card
struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void
    
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(premiumManager.getProductDisplayName(product))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(premiumManager.getProductDescription(product))
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(premiumManager.getProductPrice(product))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.focusBlue)
                        
                        if product.id.contains("yearly") {
                            Text("Save 40%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                }
                
                if isSelected {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.focusBlue)
                        Text("Selected")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.focusBlue)
                        Spacer()
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.focusBlue.opacity(0.1) : Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.focusBlue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PremiumUpgradeView()
}
