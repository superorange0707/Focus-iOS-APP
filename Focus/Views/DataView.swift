import SwiftUI

struct DataView: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedTab: DataTab = .stats
    
    enum DataTab: String, CaseIterable {
        case stats = "stats"
        case history = "history"
        
        func title(using localizationManager: LocalizationManager) -> String {
            switch self {
            case .stats: return localizationManager.localizedString(.stats)
            case .history: return localizationManager.localizedString(.searchHistory)
            }
        }
        
        var icon: String {
            switch self {
            case .stats: return "chart.bar.fill"
            case .history: return "clock.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Selector
                HStack(spacing: 0) {
                    ForEach(DataTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: tab.icon)
                                    .font(.title3)
                                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                                
                                Text(tab.title(using: localizationManager))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .background(Color(.systemGroupedBackground))
                
                // Content
                TabView(selection: $selectedTab) {
                    // Statistics Tab
                    StatsTabContent()
                        .tag(DataTab.stats)
                    
                    // History Tab
                    HistoryTabContent()
                        .tag(DataTab.history)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle(localizationManager.localizedString(.data))
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
    

}

struct StatsTabContent: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Hero Stats
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(localizationManager.localizedString(.stats))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Spacer()
                    }

                    HStack(spacing: 16) {
                        HeroStatCard(
                            title: localizationManager.localizedString(.totalSearches),
                            value: "\(analyticsManager.getTotalSearches())",
                            subtitle: getLocalizedSubtitle(),
                            icon: "magnifyingglass",
                            gradient: [.blue, .blue.opacity(0.7)]
                        )
                        .frame(maxWidth: .infinity)

                        HeroStatCard(
                            title: localizationManager.localizedString(.today),
                            value: "\(analyticsManager.getTodaysSearches())",
                            subtitle: getLocalizedSubtitle(),
                            icon: "calendar",
                            gradient: [.orange, .orange.opacity(0.7)]
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                
                // Platform Usage Section
                if !analyticsManager.getMostUsedPlatforms().isEmpty {
                    ModernPlatformUsageCard(platforms: analyticsManager.getMostUsedPlatforms())
                        .padding(.horizontal, 20)
                }

                // Insights Section
                ModernInsightsCard(
                    todayTimeSaved: analyticsManager.getTimeSavedToday(),
                    totalSearches: analyticsManager.getTotalSearches()
                )
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
    }
    
    private func getLocalizedSubtitle() -> String {
        switch localizationManager.currentLanguage {
        case "es": return "vs desplazamiento infinito"
        case "fr": return "vs défilement infini"
        case "de": return "vs endloses Scrollen"
        case "it": return "vs scorrimento infinito"
        case "pt": return "vs rolagem infinita"
        case "ru": return "vs бесконечная прокрутка"
        case "ja": return "vs 無限スクロール"
        case "ko": return "vs 무한 스크롤"
        case "zh": return "vs 无限滚动"
        default: return "vs endless scrolling"
        }
    }
}

struct HistoryTabContent: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @State private var selectedPlatform: Platform? = nil
    @State private var isSelectionMode = false
    @State private var selectedItems: Set<UUID> = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Platform Filter and Clear All button
            VStack(spacing: 12) {
                // Platform Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // All platforms button
                        FilterChip(
                            title: localizationManager.localizedString(.allPlatforms),
                            isSelected: selectedPlatform == nil
                        ) {
                            selectedPlatform = nil
                        }

                        // Individual platform filters
                        ForEach(Platform.allCases, id: \.self) { platform in
                            FilterChip(
                                title: platform.displayName,
                                isSelected: selectedPlatform == platform
                            ) {
                                selectedPlatform = platform
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Action buttons (only show if there's history)
                if !analyticsManager.getRecentSearchHistory().isEmpty {
                    HStack {
                        if isSelectionMode {
                            // Selection mode controls
                            Button(action: {
                                // Select all
                                selectedItems = Set(getFilteredHistory().map { $0.id })
                            }) {
                                Text("Select All")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.focusBlue)
                            }

                            Spacer()

                            Button(action: {
                                // Delete selected
                                searchHistoryManager.deleteItems(withIds: selectedItems)
                                selectedItems.removeAll()
                                isSelectionMode = false
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("Delete (\(selectedItems.count))")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(6)
                            }
                            .disabled(selectedItems.isEmpty)
                            .opacity(selectedItems.isEmpty ? 0.5 : 1.0)

                            Button(action: {
                                // Cancel selection
                                selectedItems.removeAll()
                                isSelectionMode = false
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            // Normal mode controls
                            Button(action: {
                                // Enter selection mode
                                isSelectionMode = true
                            }) {
                                Text("Select")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.focusBlue)
                            }

                            Spacer()

                            Button(action: {
                                // Clear all search history
                                searchHistoryManager.clearHistory()
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("Clear All")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 0.2), value: isSelectionMode)
                }
            }
            .padding(.vertical, 16)
            .background(Color(.systemGroupedBackground))
            
            // Search History List
            let filteredHistory = getFilteredHistory()

            if filteredHistory.isEmpty {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    VStack(spacing: 8) {
                        Text("No search history yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Text("Your search history will appear here after you perform searches")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredHistory, id: \.id) { item in
                            SearchHistoryRow(
                                item: item,
                                onRepeatSearch: {
                                    // Handle repeat search
                                    let _ = SearchService.shared.directSearch(query: item.query, platform: item.platform)
                                },
                                onDelete: isSelectionMode ? nil : {
                                    // Delete individual item properly
                                    searchHistoryManager.deleteItem(withId: item.id)
                                },
                                isSelectionMode: isSelectionMode,
                                isSelected: selectedItems.contains(item.id),
                                onSelectionToggle: {
                                    if selectedItems.contains(item.id) {
                                        selectedItems.remove(item.id)
                                    } else {
                                        selectedItems.insert(item.id)
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private func getFilteredHistory() -> [SearchHistoryItem] {
        let allHistory = analyticsManager.getRecentSearchHistory()
        
        if let platform = selectedPlatform {
            return allHistory.filter { $0.platform == platform }
        }
        return allHistory
    }
    

}



#Preview {
    DataView()
}
