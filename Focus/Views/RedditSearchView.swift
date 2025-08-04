import SwiftUI

struct RedditSearchView: View {
    let query: String
    
    @StateObject private var redditService = RedditAPIService.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSort: RedditSort = .relevance
    @State private var selectedTimeFilter: RedditTimeFilter = .all
    @State private var showingFilters = false
    @State private var selectedPost: RedditPost?
    @State private var showingPostDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter bar
                filterBar
                
                // Content
                if redditService.isLoading {
                    loadingView
                } else if let error = redditService.error {
                    errorView(error)
                } else if redditService.posts.isEmpty {
                    emptyView
                } else {
                    postsList
                }
            }
            .navigationTitle("Reddit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                filtersSheet
            }
            .sheet(item: $selectedPost) { post in
                RedditPostDetailView(post: post)
            }
        }
        .task {
            await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
        }
    }
    
    private var filterBar: some View {
        HStack {
            Menu {
                ForEach(RedditSort.allCases, id: \.self) { sort in
                    Button(sort.displayName) {
                        selectedSort = sort
                        Task {
                            await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedSort.displayName)
                    Image(systemName: "chevron.down")
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Menu {
                ForEach(RedditTimeFilter.allCases, id: \.self) { filter in
                    Button(filter.displayName) {
                        selectedTimeFilter = filter
                        Task {
                            await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedTimeFilter.displayName)
                    Image(systemName: "chevron.down")
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Text("Loading Reddit posts...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text("Error")
                .font(.headline)
                .padding(.top, 8)
            Text(error)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry") {
                Task {
                    await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
                }
            }
            .padding(.top)
            Spacer()
        }
    }
    
    private var emptyView: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No Results")
                .font(.headline)
                .padding(.top, 8)
            Text("No Reddit posts found for '\(query)'")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
    
    private var postsList: some View {
        List(redditService.posts) { post in
            RedditPostRow(post: post) {
                selectedPost = post
                showingPostDetail = true
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
        }
    }
    
    private var filtersSheet: some View {
        NavigationView {
            Form {
                Section("Sort By") {
                    Picker("Sort", selection: $selectedSort) {
                        ForEach(RedditSort.allCases, id: \.self) { sort in
                            Text(sort.displayName).tag(sort)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Section("Time Filter") {
                    Picker("Time", selection: $selectedTimeFilter) {
                        ForEach(RedditTimeFilter.allCases, id: \.self) { filter in
                            Text(filter.displayName).tag(filter)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingFilters = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        showingFilters = false
                        Task {
                            await redditService.searchPosts(query: query, sort: selectedSort, timeFilter: selectedTimeFilter)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct RedditPostRow: View {
    let post: RedditPost
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Text("r/\(post.subreddit)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("u/\(post.author)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(timeAgoString(from: post.createdDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Title
                Text(post.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                // Preview image if available
                if let imageURL = post.previewImageURL ?? post.thumbnailURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Footer
                HStack {
                    Label("\(post.score)", systemImage: "arrow.up")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Label("\(post.numComments)", systemImage: "bubble.left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if post.isVideo {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    RedditSearchView(query: "SwiftUI")
}
