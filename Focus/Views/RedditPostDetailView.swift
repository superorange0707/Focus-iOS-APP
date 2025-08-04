import SwiftUI

struct RedditPostDetailView: View {
    let post: RedditPost
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var showingWebView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    headerView
                    
                    // Title
                    Text(post.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    // Image if available
                    if let imageURL = post.previewImageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Self text if available
                    if let selftext = post.selftext, !selftext.isEmpty {
                        Text(selftext)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Stats
                    statsView
                    
                    // Actions
                    actionsView
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Reddit Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [post.redditURL])
        }
        .sheet(isPresented: $showingWebView) {
            InAppBrowserView(
                url: URL(string: post.redditURL)!,
                platform: .reddit,
                query: ""
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("r/\(post.subreddit)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("u/\(post.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(timeAgoString(from: post.createdDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if post.isVideo {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var statsView: some View {
        HStack(spacing: 24) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up")
                    .foregroundColor(.orange)
                Text("\(post.score)")
                    .fontWeight(.medium)
                Text("upvotes")
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "bubble.left")
                    .foregroundColor(.blue)
                Text("\(post.numComments)")
                    .fontWeight(.medium)
                Text("comments")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .font(.caption)
    }
    
    private var actionsView: some View {
        VStack(spacing: 12) {
            // View on Reddit button
            Button(action: { showingWebView = true }) {
                HStack {
                    Image(systemName: "safari")
                    Text("View on Reddit")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Open external link if different from Reddit
            if post.url != post.redditURL, let externalURL = URL(string: post.url) {
                Button(action: {
                    UIApplication.shared.open(externalURL)
                }) {
                    HStack {
                        Image(systemName: "link")
                        Text("Open External Link")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Enhanced In-App Browser for Reddit
struct EnhancedInAppBrowserView: View {
    let url: URL
    let platform: Platform
    let query: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var currentURL: URL?
    @State private var showingShareSheet = false
    @State private var showingAdvancedSearch = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced toolbar for Reddit
                if platform == .reddit {
                    redditToolbar
                }
                
                // Loading indicator
                if isLoading {
                    ProgressView()
                        .frame(height: 2)
                        .scaleEffect(x: 1, y: 0.5)
                }
                
                // Web view
                WebView(
                    url: url,
                    isLoading: $isLoading,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    currentURL: $currentURL
                )
            }
            .navigationTitle(platform.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!canGoBack)
                    
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!canGoForward)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if platform == .reddit {
                        Button(action: { showingAdvancedSearch = true }) {
                            Image(systemName: "magnifyingglass.circle")
                        }
                    }
                    
                    Button(action: refresh) {
                        Image(systemName: "arrow.clockwise")
                    }
                    
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(currentURL == nil)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let currentURL = currentURL {
                ShareSheet(items: [currentURL])
            }
        }
        .sheet(isPresented: $showingAdvancedSearch) {
            RedditSearchView(query: query)
        }
    }
    
    private var redditToolbar: some View {
        HStack {
            Button("Hot") {
                loadRedditSection("hot")
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button("New") {
                loadRedditSection("new")
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button("Top") {
                loadRedditSection("top")
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.green.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Spacer()
            
            Button("API View") {
                showingAdvancedSearch = true
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.purple.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private func loadRedditSection(_ section: String) {
        let newURL = URL(string: "https://www.reddit.com/\(section)")!
        NotificationCenter.default.post(name: .webViewLoadURL, object: newURL)
    }
    
    private func goBack() {
        NotificationCenter.default.post(name: .webViewGoBack, object: nil)
    }
    
    private func goForward() {
        NotificationCenter.default.post(name: .webViewGoForward, object: nil)
    }
    
    private func refresh() {
        NotificationCenter.default.post(name: .webViewRefresh, object: nil)
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let webViewLoadURL = Notification.Name("webViewLoadURL")
}

#Preview {
    RedditPostDetailView(post: RedditPost(
        id: "test",
        title: "Test Reddit Post Title",
        author: "testuser",
        subreddit: "SwiftUI",
        score: 1234,
        numComments: 56,
        created: Date().timeIntervalSince1970,
        url: "https://www.reddit.com/r/SwiftUI/test",
        permalink: "/r/SwiftUI/test",
        selftext: "This is a test post content.",
        thumbnail: nil,
        preview: nil,
        isVideo: false
    ))
}
