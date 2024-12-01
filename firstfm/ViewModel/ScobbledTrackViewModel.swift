import Foundation
import NotificationBannerSwift
import SwiftUI
import Valet
import Combine

struct Nothing: Codable {
}

class ScrobbledTrackViewModel: ObservableObject {
    let valet = getValet()

    func loveTrack(track: ScrobbledTrack) {
        performTrackAction(
            track: track, action: "track.love", successMessage: "Track liked successfully",
            failureMessage: "Failed to like track")
    }

    func unloveTrack(track: ScrobbledTrack) {
        performTrackAction(
            track: track, action: "track.unlove", successMessage: "Track unliked successfully",
            failureMessage: "Failed to unlike track")
    }

    private func performTrackAction(
        track: ScrobbledTrack, action: String, successMessage: String, failureMessage: String
    ) {
        guard let storedToken = try? valet.string(forKey: "sk") else {
            DispatchQueue.main.async {
                FloatingNotificationBanner(
                    title: "Error", subtitle: "Failed to retrieve stored token", style: .danger
                ).show()
            }
            return
        }

        LastFMAPI.request(
            lastFMMethod: action,
            args: ["artist": track.artist.name, "track": track.name, "sk": storedToken]
        ) { (_: Nothing?, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    FloatingNotificationBanner(
                        title: failureMessage, subtitle: error.localizedDescription, style: .danger
                    ).show()
                } else {
                    FloatingNotificationBanner(
                        title: successMessage, subtitle: nil, style: .success
                    ).show()
                }
            }
        }
    }
}
