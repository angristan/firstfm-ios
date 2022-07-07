import Foundation

class TopCountryViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var country: Country?
    var isLoading = true

    func getTopArtists(country: Country) {
        print("getTopArtists for \(country.name)")
        self.isLoading = true

        LastFMAPI.request(lastFMMethod: "geo.getTopArtists", args: ["limit": "30", "country": country.name]) { (data: TopCountryArtistsResponse?, _) -> Void in
            self.isLoading = false

            if let data = data {
                var artists = data.topartists.artist

                for index in artists.indices where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.artists = artists
                    // Let's stop the loader, the images will be loaded aynchronously
                    self.isLoading = false
                }

                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
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
