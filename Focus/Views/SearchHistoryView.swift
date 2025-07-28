import SwiftUI

// MARK: - Search History View
struct SearchHistoryView: View {
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var searchService = SearchService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var selectedPlatform: Platform?
    
    var filteredHistory: [SearchHistoryItem] {
        var history = searchHistoryManager.searchHistory
        
        // Filter by search text
        if !searchText.isEmpty {
            history = history.filter { item in
                item.query.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by platform
        if let platform = selectedPlatform {
            history = history.filter { $0.platform == platform }
        }
        
        return history
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter bar
                VStack(spacing: 12) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondaryText)
                        
                        TextField("Search history...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondaryText)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    
                    // Platform filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // All platforms button
                            FilterChip(
                                title: "All",
                                isSelected: selectedPlatform == nil,
                                action: { selectedPlatform = nil }
                            )
                            
                            // Individual platform filters
                            ForEach(Platform.allCases, id: \.self) { platform in
                                FilterChip(
                                    title: platform.displayName,
                                    isSelected: selectedPlatform == platform,
                                    action: { 
                                        selectedPlatform = selectedPlatform == platform ? nil : platform
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.backgroundPrimary)
                
                // History list
                if filteredHistory.isEmpty {
                    EmptyHistoryView(hasSearches: !searchHistoryManager.searchHistory.isEmpty)
                } else {
                    List {
                        ForEach(filteredHistory) { item in
                            SearchHistoryRow(
                                item: item,
                                onRepeatSearch: {
                                    // Repeat search
                                    searchService.directSearch(query: item.query, platform: item.platform)
                                    dismiss()
                                },
                                onDelete: {
                                    // Delete individual item properly
                                    searchHistoryManager.deleteItem(withId: item.id)
                                }
                            )
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !searchHistoryManager.searchHistory.isEmpty {
                        Button("Clear All") {
                            searchHistoryManager.clearHistory()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredHistory[$0].id }
        searchHistoryManager.deleteItems(withIds: Set(itemsToDelete))
    }
}

// MARK: - Search History Row
struct SearchHistoryRow: View {
    let item: SearchHistoryItem
    let onRepeatSearch: () -> Void
    let onDelete: (() -> Void)?
    let isSelectionMode: Bool
    let isSelected: Bool
    let onSelectionToggle: (() -> Void)?

    init(
        item: SearchHistoryItem,
        onRepeatSearch: @escaping () -> Void,
        onDelete: (() -> Void)? = nil,
        isSelectionMode: Bool = false,
        isSelected: Bool = false,
        onSelectionToggle: (() -> Void)? = nil
    ) {
        self.item = item
        self.onRepeatSearch = onRepeatSearch
        self.onDelete = onDelete
        self.isSelectionMode = isSelectionMode
        self.isSelected = isSelected
        self.onSelectionToggle = onSelectionToggle
    }

    var body: some View {
        HStack(spacing: 12) {
            // Selection circle (in selection mode)
            if isSelectionMode {
                Button(action: {
                    onSelectionToggle?()
                }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .focusBlue : .secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Platform icon
            Image(item.platform.assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .background(Color.cardBackground)
                .cornerRadius(8)

            // Search details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.query)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                HStack {
                    Text(item.platform.displayName)
                        .font(.caption)
                        .foregroundColor(.focusBlue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.focusBlue.opacity(0.1))
                        .cornerRadius(4)

                    Text(item.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    Spacer()
                }
            }
            
            Spacer()

            // Action buttons (hidden in selection mode)
            if !isSelectionMode {
                HStack(spacing: 12) {
                    // Delete button
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                                .frame(width: 32, height: 32)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    // Repeat search button
                    Button(action: onRepeatSearch) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.focusBlue)
                            .frame(width: 32, height: 32)
                            .background(Color.focusBlue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelectionMode {
                onSelectionToggle?()
            } else {
                onRepeatSearch()
            }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .focusBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.focusBlue : Color.focusBlue.opacity(0.1))
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Empty History View
struct EmptyHistoryView: View {
    let hasSearches: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasSearches ? "magnifyingglass" : "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(.secondaryText)
            
            Text(hasSearches ? "No matching searches" : "No search history yet")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.secondaryText)
            
            Text(hasSearches ? "Try adjusting your search or filters" : "Your search history will appear here after you perform searches")
                .font(.subheadline)
                .foregroundColor(.tertiaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    SearchHistoryView()
}
