import SwiftUI
import UIKit

struct SharePreviewView: View {
    let image: UIImage
    let onShare: () -> Void
    let onClose: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ScrollView {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .padding()
                }

                HStack(spacing: 12) {
                    Button(action: onClose) {
                        Text("Close")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(.secondarySystemBackground))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }

                    Button(action: onShare) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share…")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(LinearGradient(colors: [.blue, .blue.opacity(0.85)], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .navigationTitle("Share Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { onClose() }
                }
            }
        }
    }
}

#Preview {
    SharePreviewView(image: UIImage(systemName: "photo")!, onShare: {}, onClose: {})
}


