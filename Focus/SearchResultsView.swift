import SwiftUI
import SafariServices

struct SearchResultsView: View {
    let results: [SearchResult]
    let platform: Platform
    let onDismiss: () -> Void
    @State private var selectedResult: SearchResult?
    @State private var showingDetail = false
    
    var body: some View {
        ZStack {
            // Glassy background overlay
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("\(results.count) Results")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
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
                .cornerRadius(18)
                .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.08), radius: 8, x: 0, y: 2)
                
                // Results list
                ScrollView {
                    LazyVStack(spacing: 18) {
                        ForEach(results) { result in
                            SearchResultCard(
                                result: result,
                                onTap: {
                                    selectedResult = result
                                    showingDetail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(28, corners: [.topLeft, .topRight])
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.10), radius: 18, x: 0, y: 8)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.85)
        }
        .sheet(isPresented: $showingDetail) {
            if let result = selectedResult {
                ResultDetailView(result: result)
            }
        }
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    let onTap: () -> Void
    @State private var showingPreview = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Thumbnail
                if let url = result.thumbnailURL, let imageURL = URL(string: url) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        default:
                            Color.gray.opacity(0.12)
                        }
                    }
                    .frame(width: 64, height: 64)
                    .cornerRadius(14)
                    .clipped()
                } else {
                    Color.gray.opacity(0.10)
                        .frame(width: 64, height: 64)
                        .cornerRadius(14)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(result.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    // Subtitle (channel/user/metadata)
                    if let channel = result.metadata["channel"] ?? result.metadata["user"] ?? result.metadata["subreddit"] {
                        Text(channel)
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.7))
                            .lineLimit(1)
                    }
                    // Description
                    Text(result.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                // Platform icon badge
                Image(result.platform.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Circle())
                    .shadow(color: result.platform.color.opacity(0.12), radius: 4, x: 0, y: 2)
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingPreview) {
            ResultPreviewView(result: result)
        }
    }
}

struct ResultDetailView: View {
    let result: SearchResult
    @Environment(\.dismiss) private var dismiss
    @State private var showingSafari = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Platform header
                    HStack {
                        Image(systemName: result.platform.icon)
                            .foregroundColor(result.platform.color)
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text(result.platform.displayName)
                                .font(.headline)
                                .fontWeight(.semibold)
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
                        
                        // Preview content
                        if let previewContent = result.previewContent {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "text.quote")
                                        .foregroundColor(result.platform.color)
                                    Text("Preview")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                Text(previewContent)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Metadata
                        if !result.metadata.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Details")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
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
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            showingSafari = true
                        }) {
                            HStack {
                                Image(systemName: "safari")
                                Text("Open in Safari")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(result.platform.color)
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            openInNativeApp()
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
                        
                        Button(action: {
                            shareContent()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding()
            }
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
        .sheet(isPresented: $showingSafari) {
            SafariView(url: URL(string: result.url) ?? URL(string: "https://google.com")!)
        }
    }
    
    private var typeIndicator: String {
        switch result.type {
        case .video: return "Video"
        case .post: return "Post"
        case .article: return "Article"
        case .image: return "Image"
        case .user: return "User"
        case .website: return "Website"
        case .news: return "News"
        case .product: return "Product"
        }
    }
    
    private func openInNativeApp() {
        let success = URLSchemeHandler.shared.openInNativeApp(platform: result.platform, url: result.url)
        if !success {
            showingSafari = true
        }
    }
    
    private func shareContent() {
        let activityVC = UIActivityViewController(
            activityItems: [result.title, result.url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct ResultPreviewView: View {
    let result: SearchResult
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Preview header
                HStack {
                    Image(systemName: result.platform.icon)
                        .foregroundColor(result.platform.color)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Preview")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(result.platform.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                
                // Preview content
                VStack(alignment: .leading, spacing: 15) {
                    Text(result.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let previewContent = result.previewContent {
                        Text(previewContent)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    
                    Text(result.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Action button
                Button(action: {
                    let success = URLSchemeHandler.shared.openInNativeApp(platform: result.platform, url: result.url)
                    if !success {
                        URLSchemeHandler.shared.openInBrowser(url: result.url)
                    }
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.up.right.square")
                        Text("Open in \(result.platform.displayName)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(result.platform.color)
                    .cornerRadius(15)
                }
            }
            .padding()
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Safari View for better web browsing experience
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
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
        results: [
            SearchResult(
                title: "Preview Video",
                description: "This is a preview video.",
                url: "https://youtube.com/watch?v=xxxx",
                thumbnailURL: nil,
                platform: .youtube,
                type: .video,
                metadata: ["channel": "Preview Channel", "published": "2024-01-01"],
                previewContent: nil,
                directAction: .openInApp
            )
        ],
        platform: .youtube,
        onDismiss: {}
    )
} 