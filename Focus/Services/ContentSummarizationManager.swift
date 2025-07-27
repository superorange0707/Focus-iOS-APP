import Foundation
import SwiftUI

// MARK: - Content Summarization Manager
@MainActor
class ContentSummarizationManager: ObservableObject {
    static let shared = ContentSummarizationManager()
    
    @Published var isProcessing = false
    @Published var summaryCredits = 50 // Monthly credits for premium users
    @Published var lastResetDate = Date()
    
    private let apiKey = "your-openai-api-key" // Configure in production
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let creditsKey = "summary_credits"
    private let resetDateKey = "credits_reset_date"
    
    private init() {
        loadCredits()
        checkMonthlyReset()
    }
    
    // MARK: - Public Methods
    
    func summarizeContent(_ content: ContentToSummarize) async -> SummaryResult {
        guard canUseSummaryFeature() else {
            return .failure(.insufficientCredits)
        }
        
        guard PremiumManager.shared.isPremiumFeatureAvailable(.contentSummary) else {
            return .failure(.premiumRequired)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let summary = try await performSummarization(content)
            decrementCredits()
            return .success(summary)
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
    
    func canUseSummaryFeature() -> Bool {
        return summaryCredits > 0 && PremiumManager.shared.isPremiumFeatureAvailable(.contentSummary)
    }
    
    func getRemainingCredits() -> Int {
        return summaryCredits
    }
    
    // MARK: - Private Methods
    
    private func performSummarization(_ content: ContentToSummarize) async throws -> ContentSummary {
        let prompt = buildPrompt(for: content)
        let requestBody = buildAPIRequest(prompt: prompt)
        
        guard let url = URL(string: baseURL) else {
            throw SummarizationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SummarizationError.apiError
        }
        
        let apiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let summaryText = apiResponse.choices.first?.message.content else {
            throw SummarizationError.invalidResponse
        }
        
        return ContentSummary(
            originalContent: content,
            summaryText: summaryText,
            keyPoints: extractKeyPoints(from: summaryText),
            timestamp: Date(),
            wordCount: summaryText.split(separator: " ").count
        )
    }
    
    private func buildPrompt(for content: ContentToSummarize) -> String {
        switch content.type {
        case .video:
            return """
            Please provide a concise summary of this video content in 3-4 sentences, followed by 3-5 key points:
            
            Title: \(content.title)
            Description: \(content.description)
            Duration: \(content.metadata["duration"] ?? "Unknown")
            
            Focus on the main topics, key insights, and actionable information. Format as:
            Summary: [3-4 sentence summary]
            Key Points:
            • [Point 1]
            • [Point 2]
            • [Point 3]
            """
            
        case .post:
            return """
            Please provide a concise summary of this social media post in 2-3 sentences, followed by key points:
            
            Content: \(content.description)
            Platform: \(content.metadata["platform"] ?? "Unknown")
            
            Focus on the main message, important information, and key takeaways. Format as:
            Summary: [2-3 sentence summary]
            Key Points:
            • [Point 1]
            • [Point 2]
            """
            
        case .article:
            return """
            Please provide a comprehensive summary of this article in 4-5 sentences, followed by key points:
            
            Title: \(content.title)
            Content: \(content.description)
            
            Focus on the main arguments, conclusions, and important details. Format as:
            Summary: [4-5 sentence summary]
            Key Points:
            • [Point 1]
            • [Point 2]
            • [Point 3]
            • [Point 4]
            """
        }
    }
    
    private func buildAPIRequest(prompt: String) -> [String: Any] {
        return [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a helpful assistant that creates concise, accurate summaries of content. Always format your response with a Summary section followed by Key Points as bullet points."
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 300,
            "temperature": 0.3
        ]
    }
    
    private func extractKeyPoints(from summary: String) -> [String] {
        let lines = summary.components(separatedBy: .newlines)
        var keyPoints: [String] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("•") || trimmed.hasPrefix("-") || trimmed.hasPrefix("*") {
                let point = trimmed.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
                if !point.isEmpty {
                    keyPoints.append(point)
                }
            }
        }
        
        return keyPoints
    }
    
    // MARK: - Credits Management
    
    private func loadCredits() {
        summaryCredits = UserDefaults.standard.integer(forKey: creditsKey)
        if summaryCredits == 0 {
            summaryCredits = 50 // Default monthly credits
        }
        
        if let resetDate = UserDefaults.standard.object(forKey: resetDateKey) as? Date {
            lastResetDate = resetDate
        }
    }
    
    private func saveCredits() {
        UserDefaults.standard.set(summaryCredits, forKey: creditsKey)
        UserDefaults.standard.set(lastResetDate, forKey: resetDateKey)
    }
    
    private func decrementCredits() {
        summaryCredits = max(0, summaryCredits - 1)
        saveCredits()
    }
    
    private func checkMonthlyReset() {
        let calendar = Calendar.current
        let now = Date()
        
        if !calendar.isDate(lastResetDate, equalTo: now, toGranularity: .month) {
            // Reset credits for new month
            summaryCredits = 50
            lastResetDate = now
            saveCredits()
        }
    }
}

// MARK: - Data Models

struct ContentToSummarize {
    let id: String
    let title: String
    let description: String
    let type: ContentType
    let url: String
    let metadata: [String: String]
    
    enum ContentType {
        case video
        case post
        case article
    }
}

struct ContentSummary: Identifiable, Codable {
    let id = UUID()
    let originalContent: ContentToSummarize
    let summaryText: String
    let keyPoints: [String]
    let timestamp: Date
    let wordCount: Int
    
    var formattedSummary: String {
        let summarySection = summaryText.components(separatedBy: "Key Points:").first ?? summaryText
        return summarySection.replacingOccurrences(of: "Summary:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension ContentToSummarize: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, description, type, url, metadata
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        metadata = try container.decode([String: String].self, forKey: .metadata)
        
        let typeString = try container.decode(String.self, forKey: .type)
        switch typeString {
        case "video": type = .video
        case "post": type = .post
        case "article": type = .article
        default: type = .post
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(url, forKey: .url)
        try container.encode(metadata, forKey: .metadata)
        
        let typeString: String
        switch type {
        case .video: typeString = "video"
        case .post: typeString = "post"
        case .article: typeString = "article"
        }
        try container.encode(typeString, forKey: .type)
    }
}

enum SummaryResult {
    case success(ContentSummary)
    case failure(SummarizationError)
}

enum SummarizationError: Error, LocalizedError {
    case premiumRequired
    case insufficientCredits
    case networkError(String)
    case invalidURL
    case apiError
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .premiumRequired:
            return "Premium subscription required for content summarization"
        case .insufficientCredits:
            return "No summary credits remaining this month"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidURL:
            return "Invalid API URL"
        case .apiError:
            return "API request failed"
        case .invalidResponse:
            return "Invalid API response"
        }
    }
}

// MARK: - OpenAI API Response Models

private struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}
