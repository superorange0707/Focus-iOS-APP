import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Preferences Card
                    ModernPreferencesCard()

                    // Data Management Card
                    DataManagementCard()

                    // About & Support Card
                    ModernAboutCard()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

// MARK: - Data Management Card
struct DataManagementCard: View {
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedRetentionPeriod: DataRetentionPeriod = .month
    @State private var showingExportView = false
    @State private var showingClearConfirmation = false
    @State private var automaticPlatformOrder = true
    
    enum DataRetentionPeriod: String, CaseIterable {
        case week = "7 Days"
        case month = "30 Days"
        case forever = "Forever"
        
        var days: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .forever: return nil
            }
        }
        
        var localizedDisplayName: String {
            switch self {
            case .week: return LocalizationManager.shared.localizedString(.sevenDays)
            case .month: return LocalizationManager.shared.localizedString(.thirtyDays)
            case .forever: return LocalizationManager.shared.localizedString(.forever)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "externaldrive.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text(localizationManager.localizedString(.dataManagement))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Data Retention Setting
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(localizationManager.localizedString(.dataRetentionPeriod))
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(localizationManager.localizedString(.retentionDescription))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Picker("Retention Period", selection: $selectedRetentionPeriod) {
                        ForEach(DataRetentionPeriod.allCases, id: \.self) { period in
                            Text(period.localizedDisplayName).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedRetentionPeriod) { _, period in
                        if let days = period.days {
                            searchHistoryManager.cleanupOldHistory(olderThan: days)
                        }
                    }
                }
                
                Divider()
                
                // Platform Order Setting
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(localizationManager.localizedString(.platformOrder))
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(automaticPlatformOrder ? localizationManager.localizedString(.autoSortedByUsage) : "Manual order maintained")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $automaticPlatformOrder)
                            .labelsHidden()
                    }
                }
                
                Divider()
                
                // Data Export
                Button(action: { showingExportView = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(localizationManager.localizedString(.exportData))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text(localizationManager.localizedString(.exportDataDescription))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                
                // Clear Data
                Button(action: { showingClearConfirmation = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(localizationManager.localizedString(.clearAllData))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                            
                            Text(localizationManager.localizedString(.clearAllDataDescription))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showingExportView) {
            DataExportView()
        }
        .alert(localizationManager.localizedString(.clearAllData), isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                searchHistoryManager.clearHistory()
                // Reset analytics if needed
                UsageAnalyticsManager.shared.analytics = UsageAnalytics()
            }
        } message: {
            Text("This will permanently delete all your search history and usage statistics. This action cannot be undone.")
        }
    }
}

// MARK: - Modern Card Components





struct ModernPreferencesCard: View {
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguageSelector = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "gearshape.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)

                Text(localizationManager.localizedString(.preferences))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                // Language Settings
                ModernSettingRow(
                    icon: "globe",
                    title: localizationManager.localizedString(.language),
                    value: userPreferences.preferences.autoDetectLanguage ? localizationManager.localizedString(.autoDetect) : localizationManager.getLanguageName(for: localizationManager.currentLanguage),
                    action: { showingLanguageSelector = true }
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showingLanguageSelector) {
            LanguageSelectorView()
        }
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
                // Premium features will be added here when available
                Text("Premium features coming soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// ModernUsageDataCard removed - functionality moved to Data tab

struct ModernAboutCard: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingSupportFAQ = false
    // Language selector moved to Preferences

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

                // Language settings moved to Preferences

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
        // Language selector sheet moved to Preferences
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
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
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
