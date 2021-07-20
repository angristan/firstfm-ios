import Foundation

class SearchViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var isLoading = false

    func searchForArtist(artist: String) {
        self.isLoading = true

        LastFMAPI.request(lastFMMethod: "artist.search", args: ["artist": artist]) { (data: ArtistSearchResponse?, _) -> Void in
            self.isLoading = false

            if let data = data {
                var artists = data.results.artistmatches.artist

                for index in artists.indices where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.artists = artists
                    // Let's stop the loader, the images will be loaded aynchronously
                    self.isLoading = false
                }

                for (index, artist) in artists.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            artists[index].image[0].url = imageURL
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.artists = artists
                }
            }
        }
    }
}
