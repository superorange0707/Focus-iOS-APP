import SwiftUI

struct SearchResultsView: View {
    let results: [SearchResult]
    let platform: Platform
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("\(results.count) Results")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                
                // Results list
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(results) { result in
                            SearchResultCard(result: result)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(25, corners: [.topLeft, .topRight])
            .frame(maxHeight: UIScreen.main.bounds.height * 0.8)
        }
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with platform info
                HStack {
                    Image(systemName: result.platform.icon)
                        .foregroundColor(result.platform.color)
                        .font(.title3)
                    
                    Text(result.platform.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Type indicator
                    Text(typeIndicator)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(result.platform.color.opacity(0.2))
                        .foregroundColor(result.platform.color)
                        .cornerRadius(8)
                }
                
                // Title
                Text(result.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // Description
                Text(result.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                // Metadata
                if !result.metadata.isEmpty {
                    HStack(spacing: 15) {
                        ForEach(Array(result.metadata.keys.sorted()), id: \.self) { key in
                            if let value = result.metadata[key] {
                                HStack(spacing: 4) {
                                    Image(systemName: metadataIcon(for: key))
                                        .font(.caption2)
                                    Text(value)
                                        .font(.caption2)
                                }
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ResultDetailView(result: result)
        }
    }
    
    private var typeIndicator: String {
        switch result.type {
        case .video: return "VIDEO"
        case .post: return "POST"
        case .article: return "ARTICLE"
        case .image: return "IMAGE"
        case .user: return "USER"
        }
    }
    
    private func metadataIcon(for key: String) -> String {
        switch key {
        case "duration": return "clock"
        case "views": return "eye"
        case "channel": return "person"
        case "upvotes": return "arrow.up"
        case "comments": return "bubble.left"
        case "subreddit": return "r.circle"
        default: return "info.circle"
        }
    }
}

struct ResultDetailView: View {
    let result: SearchResult
    @Environment(\.dismiss) private var dismiss
    @State private var showingWebView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Platform header
                HStack {
                    Image(systemName: result.platform.icon)
                        .foregroundColor(result.platform.color)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text(result.platform.displayName)
                            .font(.headline)
                        Text(typeIndicator)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                
                // Content
                VStack(alignment: .leading, spacing: 15) {
                    Text(result.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(result.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Metadata
                    if !result.metadata.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Details")
                                .font(.headline)
                            
                            ForEach(Array(result.metadata.keys.sorted()), id: \.self) { key in
                                if let value = result.metadata[key] {
                                    HStack {
                                        Text(key.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(value)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: {
                        showingWebView = true
                    }) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Open in Browser")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(result.platform.color)
                        .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Try to open in native app
                        if let url = URL(string: result.url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.right.square")
                            Text("Open in \(result.platform.displayName)")
                        }
                        .font(.headline)
                        .foregroundColor(result.platform.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(result.platform.color, lineWidth: 1)
                        )
                    }
                }
            }
            .padding()
            .navigationTitle("Result Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingWebView) {
            WebView(url: URL(string: result.url) ?? URL(string: "https://google.com")!)
        }
    }
    
    private var typeIndicator: String {
        switch result.type {
        case .video: return "Video"
        case .post: return "Post"
        case .article: return "Article"
        case .image: return "Image"
        case .user: return "User"
        }
    }
}

// WebView for displaying content
struct WebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        let webView = UIWebView()
        webView.loadRequest(URLRequest(url: url))
        
        let viewController = UIViewController()
        viewController.view = webView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SearchResultsView(
        results: SearchService.search(query: "iOS", platform: .youtube),
        platform: .youtube,
        onDismiss: {}
    )
} 