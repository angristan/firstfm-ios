import Foundation
import SwiftUI
import NotificationBannerSwift
import Valet

class ScrobblesViewModel: ObservableObject {
    @Published var scrobbles: [ScrobbledTrack] = []
    @AppStorage("lastfm_username") var storedUsername: String?
    let myValet = getValet()
    @Published var isLoading = true
    var currentPage = 1

    func getNextPage() {
        currentPage += 1
        self.getUserScrobbles(page: currentPage)
    }

    func getUserScrobbles(page: Int = 1, clear: Bool = false) {
        self.isLoading = true
        let storedToken = try? myValet.string(forKey: "sk")

        LastFMAPI.request(lastFMMethod: "user.getRecentTracks", args: [
            "limit": "10",
            "extended": "1",
            "page": String(page),
            "user": storedUsername ?? "",
            "sk": storedToken ?? ""
        ]) { (data: RecentTracksResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load scrobbles", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    (self.scrobbles = self.scrobbles)
                }
            }

            if let data = data {
                if Int(data.recentTracks.attr.page)! >= Int(data.recentTracks.attr.totalPages)! {
                    return
                }

                var tracks = data.recentTracks.track

                // Fix tracks that don't have images

                for index in tracks.indices {
                    if tracks[index].image[0].url == "" {
                        tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }

                    if tracks[index].image[3].url == "" {
                        tracks[index].image[3].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                }

                for (index, track) in tracks.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImageProxy.findImage(type: "track", name: "\(track.name) \(track.artist.name)") { imageURL in
                        if let imageURL = imageURL {
                            tracks[index].image[0].url = imageURL
                        }
                    }
                }

                DispatchQueue.main.async {
                    if clear {
                        self.scrobbles = tracks
                    } else {
                        print("appending \(tracks.count) tracks")
                        self.scrobbles.append(contentsOf: tracks)
                    }
                    self.isLoading = false
                }

            }
        }
    }
}
