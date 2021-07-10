//
//  TopCountryViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 10/07/2021.
//

import Foundation

class TopCountryViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var country: Country?
    var isLoading = true
    
    func getTopArtists(country: Country) {
        print("getTopArtists for \(country.name)")
        self.isLoading = true
        
        LastFMAPI.request(lastFMMethod: "geo.getTopArtists", args: ["limit": "30", "country": country.name ]) { (data: TopCountryArtistsResponse?, error) -> Void in
            self.isLoading = false
            
            if let data = data {
                var artists = data.topartists.artist
                
                for (index, _) in artists.enumerated() {
                    if artists[index].image[0].url == "" {
                        artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                }
                
                DispatchQueue.main.async {
                    self.artists = artists
                    // Let's stop the loader, the images will be loaded aynchronously
                    self.isLoading = false
                }
                
                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    self.getImageForArtist(artistName: artist.name) { imageURL in
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
    
    func getImageForArtist(artistName: String, completion: @escaping (String?) -> ()) {
        if let encodedArtistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedArtistName)&type=artist&limit=1"
            if let queryURL = URL(string: queryURLString) {
                var request = URLRequest(url: queryURL)
                
                request.setValue("application/json", forHTTPHeaderField:"Content-Type");
                
                getSpotifyToken() { spotifyToken in
                    request.setValue("Bearer \(spotifyToken)",
                                     forHTTPHeaderField:"Authorization");
                    
                    URLSession.shared.dataTask(with: request , completionHandler : { data, response, error in
                        do {
                            if let response = response {
                                let nsHTTPResponse = response as? HTTPURLResponse
                                if let statusCode = nsHTTPResponse?.statusCode {
                                    print ("spotify status code = \(statusCode)")
                                }
                                // TODO
                            }
                            if let error = error {
                                print (error)
                                // TODO
                                completion("")
                            }
                            if let data = data {
                                do{
                                    let jsonResponse = try JSONDecoder().decode(SpotifyArtistSearchResponse.self, from: data)
                                    
                                    // TODO: match image sizes
                                    if jsonResponse.artists.items.count > 0 {
                                        if jsonResponse.artists.items[0].images.count > 0 {
                                            print(jsonResponse.artists.items[0].images[0].url)
                                            completion(jsonResponse.artists.items[0].images[0].url)
                                        } else {
                                            completion("https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")
                                        }
                                    } else {
                                        completion("https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")
                                    }
                                    
                                    
                                }
                            }
                        }
                        catch {
                            print(error)
                            // TODO
                        }
                    }).resume()
                }
            }
        }
    }
    
    
}
