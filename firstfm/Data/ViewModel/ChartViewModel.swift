//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation


class ChartViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    var isLoading = true

    func getChartingArtists() {
        self.isLoading = true

        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)
        // TODO: extract API key
        let data : Data = "api_key=d404c94c63e190519d70002332f09509&method=chart.getTopArtists&limit=30".data(using: .utf8)!

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
                        let jsonResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)

                        DispatchQueue.main.async {
                            self.artists = jsonResponse.artists.artist
                            // Let's stop the loader, the images will be loaded aynchronously
                            self.isLoading = false
                        }

                        for (index, artist) in jsonResponse.artists.artist.enumerated() {
                            // Get image URL for each artist and trigger a View update through the observed object
                            getImageForArtist(artistName: artist.name) { imageURL in
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

func getImageForArtist(artistName: String, completion: @escaping (String?) -> ()) {
    if let encodedArtistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedArtistName)&type=artist&limit=1"
        if let queryURL = URL(string: queryURLString) {
            var request = URLRequest(url: queryURL)

            request.setValue("application/json", forHTTPHeaderField:"Content-Type");
            // TODO: handle token renewing
            request.setValue("Bearer BQCPv3pEYf-K7NgmsSx5Vuri0lAP-bijRLkAA8F0apgPBmCA9QsQGYeS_ONOSQdZBVBbWs2mjL1Z0VjFBDUuR6MKzYjFOtJ3m-coLD3rWjVxUl8BIs9u-ABETXbZdnFMt_glQvxZ4MzMQC9Tv-A", forHTTPHeaderField:"Authorization");

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
                            completion(jsonResponse.artists.items[0].images[0].url)
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
