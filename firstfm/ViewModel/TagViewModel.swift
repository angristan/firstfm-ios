import Foundation
import NotificationBannerSwift

class TagViewModel: ObservableObject {
    @Published var artists: [Artist] = []

    func getChartingArtists(tag: Tag) {
        LastFMAPI.request(lastFMMethod: "tag.getTopArtists", args: ["tag": tag.name, "limit": "5"]) { (data: TagTopArtistsResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load tag artists", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }

            if let data = data {
                var artists = data.topartists.artist

                for index in artists.indices where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.artists = artists
                }

                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImageProxy.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.artists[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}
