import Foundation

// MARK: - Badges Engine (P2 skeleton)
struct BadgeState: Codable, Hashable {
    var id: String
    var unlockedAt: Date?
}

class BadgesEngine: ObservableObject {
    static let shared = BadgesEngine()
    @Published var badges: [BadgeState] = []

    private init() {
        load()
    }

    func recordFirstShareUnlocked() {
        unlock(id: "first_share")
    }

    func recordSocialStarterUnlocked() {
        unlock(id: "social_starter")
    }

    func evaluateDailyChallenge(todaySavedMinutes: Int, todayEfficiency: Double) {
        if todaySavedMinutes >= 10 || todayEfficiency >= 0.70 {
            unlock(id: "seven_focus_streak")
        }
    }

    func unlockedBadges() -> [ShareBadge] {
        badges.compactMap { state in
            guard state.unlockedAt != nil else { return nil }
            switch state.id {
            case "seven_focus_streak":
                return ShareBadge(id: state.id, title: "Seven Focus Streak", iconName: "flame.fill")
            case "marathon_300":
                return ShareBadge(id: state.id, title: "Marathon 300", iconName: "figure.run")
            case "first_share":
                return ShareBadge(id: state.id, title: "First Share", iconName: "square.and.arrow.up")
            case "social_starter":
                return ShareBadge(id: state.id, title: "Social Starter", iconName: "person.2.fill")
            default:
                return nil
            }
        }
    }

    // MARK: - Persistence
    private func unlock(id: String) {
        if let index = badges.firstIndex(where: { $0.id == id }) {
            if badges[index].unlockedAt == nil { badges[index].unlockedAt = Date(); save() }
        } else {
            badges.append(BadgeState(id: id, unlockedAt: Date()))
            save()
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "badges_state"),
           let saved = try? JSONDecoder().decode([BadgeState].self, from: data) {
            badges = saved
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(badges) {
            UserDefaults.standard.set(data, forKey: "badges_state")
        }
    }
}


