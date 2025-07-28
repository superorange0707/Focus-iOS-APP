import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var showingPremiumUpgrade = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Premium Status Card
                    if premiumManager.isPremiumUser {
                        ModernPremiumStatusCard()
                    } else if premiumManager.isTrialActive {
                        ModernTrialStatusCard()
                    } else {
                        ModernUpgradePromptCard {
                            showingPremiumUpgrade = true
                        }
                    }



                    // Premium Features Card
                    if premiumManager.isPremiumUser || premiumManager.isTrialActive {
                        ModernPremiumFeaturesCard()
                    }

                    // Usage & Data Card
                    ModernUsageDataCard()

                    // About & Support Card
                    ModernAboutCard()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.settings))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
                

        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumUpgradeView()
        }

    }
}

// MARK: - Modern Card Components

struct ModernPremiumStatusCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)

                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("SkipFeed Premium")
                        .font(.headline)
                        .fontWeight(.bold)

                    Text("All features unlocked")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernTrialStatusCard: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)

                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(localizationManager.localizedString(.freeTrialActive))
                        .font(.headline)
                        .fontWeight(.bold)

                    Text("\(premiumManager.trialDaysRemaining) \(localizationManager.localizedString(.daysRemaining))")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .fontWeight(.medium)
                }

                Spacer()

                Button("Upgrade") {
                    // Show premium upgrade
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange)
                .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernUpgradePromptCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 50, height: 50)

                        Image(systemName: "crown")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Upgrade to Premium")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("3-day free trial • Unlock all features")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct ModernPremiumFeaturesCard: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.title3)
                    .foregroundColor(.yellow)

                Text(localizationManager.localizedString(.premiumFeatures))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                // Do Not Disturb
                if premiumManager.isPremiumFeatureAvailable(.doNotDisturb) {
                    ModernToggleRow(
                        icon: "moon.circle",
                        title: localizationManager.localizedString(.autoDoNotDisturb),
                        subtitle: localizationManager.localizedString(.autoDoNotDisturbDescription),
                        isOn: $userPreferences.preferences.enableDoNotDisturb
                    )
                }

                // Content Summarization
                if premiumManager.isPremiumFeatureAvailable(.contentSummary) {
                    ModernSettingRow(
                        icon: "doc.text.magnifyingglass",
                        title: localizationManager.localizedString(.aiSummarization),
                        value: "\(ContentSummarizationManager.shared.getRemainingCredits()) \(localizationManager.localizedString(.creditsLeft))",
                        action: { /* Show info */ }
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernUsageDataCard: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)

                Text(localizationManager.localizedString(.usageAndData))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                // Clear Recent Searches
                ModernActionRow(
                    icon: "trash.circle",
                    title: localizationManager.localizedString(.clearRecentSearches),
                    isDestructive: true,
                    action: {
                        SearchService.shared.recentSearches.removeAll()
                    }
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernAboutCard: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingSupportFAQ = false
    @State private var showingLanguageSelector = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)

                Text(localizationManager.localizedString(.aboutAndSupport))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "app.badge")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .frame(width: 24)

                    Text(localizationManager.localizedString(.version))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    Spacer()

                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)

                // Language Settings
                ModernSettingRow(
                    icon: "globe",
                    title: localizationManager.localizedString(.language),
                    value: userPreferences.preferences.autoDetectLanguage ? localizationManager.localizedString(.autoDetect) : localizationManager.getLanguageName(for: localizationManager.currentLanguage),
                    action: { showingLanguageSelector = true }
                )

                ModernActionRow(
                    icon: "doc.text",
                    title: localizationManager.localizedString(.privacyPolicy),
                    isDestructive: false,
                    action: { showingPrivacyPolicy = true }
                )

                ModernActionRow(
                    icon: "doc.plaintext",
                    title: localizationManager.localizedString(.termsOfService),
                    isDestructive: false,
                    action: { showingTermsOfService = true }
                )

                ModernActionRow(
                    icon: "questionmark.circle",
                    title: localizationManager.localizedString(.supportAndFAQ),
                    isDestructive: false,
                    action: { showingSupportFAQ = true }
                )

                ModernActionRow(
                    icon: "envelope",
                    title: localizationManager.localizedString(.contactUs),
                    isDestructive: false,
                    action: {
                        if let url = URL(string: "mailto:support@skipfeed.app") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showingPrivacyPolicy) {
            FormattedPrivacyPolicyView(localizationManager: localizationManager)
        }
        .sheet(isPresented: $showingLanguageSelector) {
            LanguageSelectorView()
        }
        .sheet(isPresented: $showingTermsOfService) {
            FormattedTermsOfServiceView(localizationManager: localizationManager)
        }
        .sheet(isPresented: $showingSupportFAQ) {
            FormattedSupportFAQView(localizationManager: localizationManager)
        }
    }
}

// MARK: - Modern Setting Components

struct ModernSettingRow: View {
    let icon: String
    let title: String
    let value: String
    let action: (() -> Void)?

    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    if !value.isEmpty {
                        Text(value)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer(minLength: 0)

                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(action == nil)
    }
}

struct ModernToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

struct ModernStepperRow: View {
    let icon: String
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("\(value) \(localizationManager.localizedString(.searchesPerDay))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

struct ModernActionRow: View {
    let icon: String
    let title: String
    let isDestructive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isDestructive ? .red : .blue)
                    .frame(width: 24)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isDestructive ? .red : .primary)

                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// MARK: - Language Selector View
struct LanguageSelectorView: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Auto-detect card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "location.circle.fill")
                                .font(.title3)
                                .foregroundColor(.blue)

                            Text("Auto-detect")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()
                        }

                        ModernToggleRow(
                            icon: "location.circle",
                            title: localizationManager.localizedString(.autoDetect),
                            subtitle: "\(localizationManager.localizedString(.autoDetectSubtitle)) (\(localizationManager.getLanguageName(for: localizationManager.getSystemLanguage())))",
                            isOn: $userPreferences.preferences.autoDetectLanguage
                        )
                        .onChange(of: userPreferences.preferences.autoDetectLanguage) { _, newValue in
                            userPreferences.setAutoDetectLanguage(newValue)
                        }
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)

                    // Language selection card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "globe.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)

                            Text(localizationManager.localizedString(.selectLanguage))
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()
                        }

                        VStack(spacing: 8) {
                            ForEach(localizationManager.getSupportedLanguages(), id: \.code) { language in
                                Button(action: {
                                    localizationManager.setLanguage(language.code)
                                    userPreferences.updateLanguage(language.code)
                                    dismiss()
                                }) {
                                    HStack(spacing: 12) {
                                        Text(language.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)

                                        Spacer()

                                        if localizationManager.currentLanguage == language.code && !userPreferences.preferences.autoDetectLanguage {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(userPreferences.preferences.autoDetectLanguage)
                                .opacity(userPreferences.preferences.autoDetectLanguage ? 0.5 : 1.0)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.language))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
        .onAppear {
            // Sync localization manager with user preferences
            if !userPreferences.preferences.autoDetectLanguage {
                localizationManager.setLanguage(userPreferences.preferences.preferredLanguage)
            }
        }
    }
}

#Preview {
    SettingsView()
}
