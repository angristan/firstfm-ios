//
//  SearchViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var isLoading = false
    
    // swiftlint:disable force_cast
    let lastFMAPIKey = Bundle.main.object(forInfoDictionaryKey: "LastFMAPIKey") as! String
    
    func searchForArtist(artist: String) {
        self.isLoading = true

        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)

        let data : Data = "api_key=\(lastFMAPIKey)&method=artist.search&artist=\(artist)".data(using: .utf8)!

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            do {
                if let response = response {
                    let nsHTTPResponse = response as? HTTPURLResponse
                    if let statusCode = nsHTTPResponse?.statusCode {
                        print ("status code = \(statusCode)")
                    }
                    // TODO
                }
                if let error = error {
                    print (error)
                    // TODO
                }
                if let data = data {
                    do{
                        let jsonResponse = try JSONDecoder().decode(ArtistSearchResponse.self, from: data)

                        
                        var artists = jsonResponse.results.artistmatches.artist
                        
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
                        
                        for (index, artist) in jsonResponse.results.artistmatches.artist.enumerated() {
                            // Get image URL for each artist and trigger a View update through the observed object
                            ChartViewModel().getImageForArtist(artistName: artist.name) { imageURL in
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
            catch {
                print(error)
                // TODO
            }
        }.resume()
    }
}
