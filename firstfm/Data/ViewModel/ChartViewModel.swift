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
        let data : Data = "api_key=d404c94c63e190519d70002332f09509&method=chart.getTopArtists&limit=50".data(using: .utf8)!
        
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
                        var jsonResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.artists = jsonResponse.artists.artist
                            self.isLoading = false
                        }

                        
                        let myGroup = DispatchGroup()

                        for (index, artist) in jsonResponse.artists.artist.enumerated() {
                            myGroup.enter()
                            getImageForArtist(artistName: artist.name) { imageURL in
                                if let imageURL = imageURL {
                                    jsonResponse.artists.artist[index].image[0].url = imageURL
                                    print(jsonResponse)
                                    myGroup.leave()
                                }
                            }
                        }

                        myGroup.notify(queue: .main) {
                            print("Finished all requests.")
                            DispatchQueue.main.async {
                                self.artists = jsonResponse.artists.artist
                                self.isLoading = false
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
            request.setValue("Bearer xxxx", forHTTPHeaderField:"Authorization");
            
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
                            print(data)
                            let jsonResponse = try JSONDecoder().decode(SpotifyArtistSearchResponse.self, from: data)
                            
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
