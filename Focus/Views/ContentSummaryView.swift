import SwiftUI

// MARK: - Content Summary View
struct ContentSummaryView: View {
    let content: ContentToSummarize
    @StateObject private var summaryManager = ContentSummarizationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var summary: ContentSummary?
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Original content info
                    ContentInfoCard(content: content)
                    
                    // Summary section
                    if let summary = summary {
                        SummaryCard(summary: summary)
                    } else if summaryManager.isProcessing {
                        ProcessingView()
                    } else {
                        SummaryPromptCard {
                            generateSummary()
                        }
                    }
                    
                    // Credits info
                    CreditsInfoCard()
                }
                .padding()
            }
            .navigationTitle("Content Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func generateSummary() {
        Task {
            let result = await summaryManager.summarizeContent(content)
            
            await MainActor.run {
                switch result {
                case .success(let generatedSummary):
                    self.summary = generatedSummary
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showingError = true
                }
            }
        }
    }
}

// MARK: - Content Info Card
struct ContentInfoCard: View {
    let content: ContentToSummarize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: contentIcon)
                    .font(.title2)
                    .foregroundColor(.focusBlue)
                
                Text("Original Content")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(content.type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.focusBlue)
                    .cornerRadius(8)
            }
            
            Text(content.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            if !content.description.isEmpty {
                Text(content.description)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                    .lineLimit(3)
            }
            
            // Metadata
            if !content.metadata.isEmpty {
                HStack {
                    ForEach(Array(content.metadata.prefix(2)), id: \.key) { key, value in
                        Text("\(key): \(value)")
                            .font(.caption2)
                            .foregroundColor(.tertiaryText)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
    
    private var contentIcon: String {
        switch content.type {
        case .video: return "play.rectangle"
        case .post: return "text.bubble"
        case .article: return "doc.text"
        }
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let summary: ContentSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.green)
                
                Text("AI Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(summary.wordCount) words")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            // Summary text
            Text(summary.formattedSummary)
                .font(.subheadline)
                .lineSpacing(4)
            
            // Key points
            if !summary.keyPoints.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Points")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.focusBlue)
                    
                    ForEach(Array(summary.keyPoints.enumerated()), id: \.offset) { index, point in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.subheadline)
                                .foregroundColor(.focusBlue)
                            
                            Text(point)
                                .font(.caption)
                                .lineSpacing(2)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            // Timestamp
            HStack {
                Spacer()
                Text("Generated \(summary.timestamp.formatted(.relative(presentation: .named)))")
                    .font(.caption2)
                    .foregroundColor(.tertiaryText)
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Processing View
struct ProcessingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .focusBlue))
                .scaleEffect(1.2)
            
            Text("Generating AI Summary...")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.focusBlue)
            
            Text("This may take a few seconds")
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Summary Prompt Card
struct SummaryPromptCard: View {
    let action: () -> Void
    @StateObject private var summaryManager = ContentSummarizationManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text("Generate AI Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Get a concise summary with key points extracted by AI")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
            
            if summaryManager.canUseSummaryFeature() {
                Button(action: action) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Summary")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.focusBlue)
                    .cornerRadius(12)
                }
            } else {
                VStack(spacing: 8) {
                    Text("No summary credits remaining")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                    
                    Text("Credits reset monthly with your premium subscription")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Credits Info Card
struct CreditsInfoCard: View {
    @StateObject private var summaryManager = ContentSummarizationManager.shared
    
    var body: some View {
        HStack {
            Image(systemName: "creditcard")
                .foregroundColor(.focusBlue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Summary Credits")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("\(summaryManager.getRemainingCredits()) remaining this month")
                    .font(.caption2)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            // Progress indicator
            let totalCredits = 50
            let remaining = summaryManager.getRemainingCredits()
            let progress = Double(remaining) / Double(totalCredits)
            
            CircularProgressView(progress: progress, color: progressColor(for: progress))
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    private func progressColor(for progress: Double) -> Color {
        if progress > 0.5 {
            return .green
        } else if progress > 0.2 {
            return .orange
        } else {
            return .red
        }
    }
}

// MARK: - Circular Progress View
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 3)
                .frame(width: 30, height: 30)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

// MARK: - Extensions
extension ContentToSummarize.ContentType {
    var displayName: String {
        switch self {
        case .video: return "Video"
        case .post: return "Post"
        case .article: return "Article"
        }
    }
}

#Preview {
    ContentSummaryView(
        content: ContentToSummarize(
            id: "1",
            title: "SwiftUI Tutorial: Building Modern iOS Apps",
            description: "Learn how to build beautiful iOS applications using SwiftUI with this comprehensive tutorial covering views, state management, and navigation.",
            type: .video,
            url: "https://youtube.com/watch?v=example",
            metadata: ["duration": "15:30", "views": "125K"]
        )
    )
}
