//
//  ChartData.swift
//  firstfm
//
//  Created by Stanislas Lange on 12/06/2021.
//

import Foundation


class ChartViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    @Published var tracks: [Track] = []
    var isLoading = true
    
    func getChartingArtists() {
        self.isLoading = true
        
        LastFMAPI.request(lastFMMethod: "chart.getTopArtists", config: ["limit": "30"]) { (data: ArtistResponse?, error) -> Void in
            self.isLoading = false
            
            if let data = data {
                var artists = data.artists.artist
                
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
                
                for (index, artist) in data.artists.artist.enumerated() {
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
    
    
    //
    // Track
    //
    
    func getChartingTracks() {
        self.isLoading = true
        
        LastFMAPI.request(lastFMMethod: "chart.getTopTracks", config: ["limit": "30"]) { (data: TrackResponse?, error) -> Void in
            self.isLoading = false
            
            if let data = data {
                DispatchQueue.main.async {
                    self.tracks = data.tracks.track
                }
                
                for (index, track) in data.tracks.track.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    self.getImageForTrack(trackName: track.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.tracks[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getImageForTrack(trackName: String, completion: @escaping (String?) -> ()) {
        if let encodedTrackName = trackName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedTrackName)&type=track&limit=1"
            if let queryURL = URL(string: queryURLString) {
                var request = URLRequest(url: queryURL)
                
                request.setValue("application/json", forHTTPHeaderField:"Content-Type");
                
                getSpotifyToken() { spotifyToken in
                    print("spotifyToken: \(spotifyToken)")
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
                                    let jsonResponse = try JSONDecoder().decode(SpotifyTrackSearchResponse.self, from: data)
                                    
                                    // TODO: match image sizes
                                    completion(jsonResponse.tracks.items[0].album.images[0].url)
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
