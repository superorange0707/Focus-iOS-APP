import SwiftUI
import UIKit

struct DualShareCardView: View {
    let left: ShareCardData
    let right: ShareCardData

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 16) {
                Text("SkipFeed · Local Comparison")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                HStack(spacing: 24) {
                    ShareCardView(data: left)
                        .frame(width: 760, height: 860)
                        .clipped()
                        .scaleEffect(0.7)
                    ShareCardView(data: right)
                        .frame(width: 760, height: 860)
                        .clipped()
                        .scaleEffect(0.7)
                }
                Text("Generated locally · No server upload")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .frame(width: 1600, height: 900)
    }
}

@available(iOS 16.0, *)
@MainActor
func renderDualShareCardPNG(left: ShareCardData, right: ShareCardData) -> UIImage? {
    let view = DualShareCardView(left: left, right: right)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}


