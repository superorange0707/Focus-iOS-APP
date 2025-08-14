import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

// MARK: - Simple Peer Stats and Codec (P1 skeleton)
struct PeerPlatform: Codable, Hashable {
    let name: String
    let percent: Double
}

struct PeerStats: Codable, Hashable {
    let v: Int
    let u: String
    let p: String
    let ts: Int
    let fs: Int
    let eff: Double
    let tp: [PeerPlatform]
    let tr: [Int]
    let gen: String
}

enum StatsCodeError: Error {
    case invalidBase64
    case decodeFailed
}

func base64urlEncode(_ data: Data) -> String {
    let b64 = data.base64EncodedString()
    return b64.replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

func base64urlDecode(_ s: String) -> Data? {
    var b64 = s.replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    let pad = 4 - (b64.count % 4)
    if pad < 4 { b64 += String(repeating: "=", count: pad) }
    return Data(base64Encoded: b64)
}

func encodePeerStats(_ stats: PeerStats) throws -> String {
    let json = try JSONEncoder().encode(stats)
    return base64urlEncode(json)
}

func decodePeerStats(_ code: String) throws -> PeerStats {
    guard let data = base64urlDecode(code) else { throw StatsCodeError.invalidBase64 }
    do {
        return try JSONDecoder().decode(PeerStats.self, from: data)
    } catch {
        throw StatsCodeError.decodeFailed
    }
}

// MARK: - Compare View (P1 skeleton)
struct CompareView: View {
    @State private var inputCode: String = ""
    @State private var decodedPeer: PeerStats?
    @State private var errorMessage: String?
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @State private var showingShare = false
    @State private var shareItems: [Any] = []
    @State private var qrImage: UIImage?

    var body: some View {
        NavigationView {
            Form {
                // Export own stats code
                Section("Share Your Stats") {
                    Button("Generate & Copy Code") { generateAndCopyCode() }
                    Button("Share Code…") { generateAndShareCode() }
                    Button("Show QR Code") { generateQRCode() }
                    if let qr = qrImage {
                        Image(uiImage: qr)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .padding(.vertical, 8)
                    }
                }
                Section("Import Stats Code") {
                    TextField("Paste code here", text: $inputCode)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Decode") { decode() }
                    Button("Try Sample Code (Offline)") { inputCode = sampleCode(); decode() }
                }

                if let peer = decodedPeer {
                    Section("Peer Summary") {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(peer.u).font(.headline)
                                Text("Time Saved: \(peer.ts)m")
                                Text("Focus: \(peer.fs)")
                                Text("Efficiency: \(String(format: "%.2f", peer.eff))")
                            }
                            Spacer()
                        }
                        Button("Generate Comparison Card") { generateDualCard(peer) }
                    }
                }

                if let error = errorMessage {
                    Section {
                        Text(error).foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Compare")
            .sheet(isPresented: $showingShare) {
                ActivityViewController(activityItems: shareItems)
            }
        }
    }

    private func decode() {
        errorMessage = nil
        do {
            let peer = try decodePeerStats(inputCode)
            decodedPeer = peer
        } catch {
            errorMessage = "Invalid code"
        }
    }

    private func generatePeerStats() -> PeerStats {
        let totalMin = Int(analyticsManager.getTimeSaved() / 60)
        let todayMin = Int(analyticsManager.getTimeSavedToday() / 60)
        let focusScore = min(100, analyticsManager.getTotalSearches() * 2)
        let efficiency = 0.74
        let period = "7d"
        let platforms = analyticsManager.getMostUsedPlatforms()
        let sum = max(1, platforms.reduce(0) { $0 + $1.1 })
        let tpPairs: [PeerPlatform] = Array(platforms.prefix(4)).map { PeerPlatform(name: $0.0.displayName, percent: Double($0.1) / Double(sum)) }
        let tr = buildTrend(days: 7)
        let dateStr = DateFormatter.dayFormatter.string(from: Date())
        return PeerStats(v: 1, u: getDisplayName(), p: period, ts: todayMin == 0 ? totalMin : todayMin, fs: focusScore, eff: efficiency, tp: tpPairs, tr: tr, gen: dateStr)
    }

    private func generateAndCopyCode() {
        do {
            let code = try encodePeerStats(generatePeerStats())
            UIPasteboard.general.string = code
            BadgesEngine.shared.recordSocialStarterUnlocked()
        } catch {
            errorMessage = "Failed to generate code"
        }
    }

    private func generateAndShareCode() {
        do {
            let code = try encodePeerStats(generatePeerStats())
            shareItems = [code]
            showingShare = true
            BadgesEngine.shared.recordSocialStarterUnlocked()
        } catch {
            errorMessage = "Failed to generate code"
        }
    }

    private func generateQRCode() {
        do {
            let code = try encodePeerStats(generatePeerStats())
            qrImage = createQRCode(from: code)
        } catch {
            errorMessage = "Failed to generate QR"
        }
    }

    private func createQRCode(from string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(Data(string.utf8), forKey: "inputMessage")
        filter.correctionLevel = "Q"
        guard let outputImage = filter.outputImage else { return nil }
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 8, y: 8))
        let context = CIContext()
        if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    private func buildTrend(days: Int) -> [Int] {
        let calendar = Calendar.current
        let endDate = Date()
        var result: [Int] = []
        for dayOffset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: endDate) else { continue }
            let dateKey = DateFormatter.dayFormatter.string(from: date)
            let count = analyticsManager.analytics.dailySearches[dateKey] ?? 0
            result.append(count)
        }
        return result
    }

    private func getDisplayName() -> String {
        let userId = UIDevice.current.identifierForVendor?.uuidString.prefix(4) ?? "0000"
        return "User-\(userId)"
    }

    private func generateDualCard(_ peer: PeerStats) {
        guard #available(iOS 16.0, *) else { return }
        let me = generatePeerStats()
        let myData = ShareCardData(
            displayName: me.u,
            periodLabel: me.p == "7d" ? "Last 7 days" : "Last 30 days",
            todaySavedMin: me.ts,
            totalSavedMin: me.ts,
            focusScore: me.fs,
            efficiencyRate: me.eff,
            topPlatforms: me.tp.map { SharePlatform(name: $0.name, percent: $0.percent * 100) },
            trend: me.tr,
            badges: BadgesEngine.shared.unlockedBadges(),
            generatedAt: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        )

        let peerData = ShareCardData(
            displayName: peer.u,
            periodLabel: peer.p == "7d" ? "Last 7 days" : "Last 30 days",
            todaySavedMin: peer.ts,
            totalSavedMin: peer.ts,
            focusScore: peer.fs,
            efficiencyRate: peer.eff,
            topPlatforms: peer.tp.map { SharePlatform(name: $0.name, percent: $0.percent * 100) },
            trend: peer.tr,
            badges: [],
            generatedAt: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        )

        if let img = renderDualShareCardPNG(left: myData, right: peerData) {
            shareItems = [img]
            showingShare = true
        }
    }

    private func sampleCode() -> String {
        let demo = PeerStats(
            v: 1,
            u: "Alex",
            p: "7d",
            ts: 186,
            fs: 82,
            eff: 0.74,
            tp: [PeerPlatform(name: "YouTube", percent: 0.42), PeerPlatform(name: "Reddit", percent: 0.31), PeerPlatform(name: "Google", percent: 0.27)],
            tr: [12,9,15,13,20,18,22],
            gen: DateFormatter.dayFormatter.string(from: Date())
        )
        return (try? encodePeerStats(demo)) ?? ""
    }
}

#Preview {
    CompareView()
}


