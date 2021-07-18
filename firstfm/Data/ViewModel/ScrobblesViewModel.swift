//
//  ScrobblesViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import Foundation
import SwiftUI
import NotificationBannerSwift

class ScrobblesViewModel: ObservableObject {
    @Published var scrobbles: [ScrobbledTrack] = []
    @AppStorage("lastfm_username") var storedUsername: String?
    @AppStorage("lastfm_sk") var storedToken: String?
    var isLoading = true

    func getUserScrobbles() {
        self.isLoading = true

        LastFMAPI.request(lastFMMethod: "user.getRecentTracks", args: [
            "limit": "30",
            "extended": "1",
            "user": storedUsername ?? "",
            "sk": storedToken ?? ""
        ]) { (data: RecentTracksResponse?, error) -> Void in
            self.isLoading = false

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load scrobbles", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.scrobbles = self.scrobbles
                }
            }

            if let data = data {
                var tracks = data.recentTracks.track

                // Fix tracks that don't have images

                for index in tracks.indices() {
                    if tracks[index].image[0].url == "" {
                        tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }

                    if tracks[index].image[3].url == "" {
                        tracks[index].image[3].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                }

                DispatchQueue.main.async {
                    self.scrobbles = tracks
                }

                for (index, track) in tracks.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "track", name: "\(track.name) \(track.artist.name)") { imageURL in
                        if let imageURL = imageURL {
                            tracks[index].image[0].url = imageURL
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.scrobbles = tracks
                }

            }
        }
    }
}
