//
//  ScrobblesViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 08/07/2021.
//

import Foundation
import SwiftUI

class ScrobblesViewModel: ObservableObject {
    @Published var scrobbles: [ScrobbledTrack] = []
    @AppStorage("lastfm_username") var storedUsername: String?
    var isLoading = true
    
    // swiftlint:disable force_cast
    let lastFMAPIKey = Bundle.main.object(forInfoDictionaryKey: "LastFMAPIKey") as! String
    
    func getUserScrobbles() {
        self.isLoading = true
        
        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)
        let data : Data = "api_key=\(lastFMAPIKey)&method=user.getRecentTracks&user=\(storedUsername ?? "")&limit=30".data(using: .utf8)!
        
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
                        let jsonResponse = try JSONDecoder().decode(RecentTracksResponse.self, from: data)
                        
                        
                        var tracks = jsonResponse.recentTracks.track
                        
                        // Fix tracks that don't have images
                        
                        for (index, _) in jsonResponse.recentTracks.track.enumerated() {
                            if jsonResponse.recentTracks.track[index].image[0].url == "" {
                                tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                            }
                            
                            if jsonResponse.recentTracks.track[index].image[3].url == "" {
                                tracks[index].image[3].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                            }
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.scrobbles = tracks
                            print(self.scrobbles)
                            
                            // Let's stop the loader, the images will be loaded aynchronously
                            self.isLoading = false
                        }
                        
                        for (index, track) in jsonResponse.recentTracks.track.enumerated() {
                            // Get image URL for each track and trigger a View update through the observed object
                            self.getImageForTrack(trackName: track.name) { imageURL in
                                if let imageURL = imageURL {
                                    DispatchQueue.main.async {
                                        self.scrobbles[index].image[0].url = imageURL
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
                                    
                                    print(jsonResponse)
                                    
                                    // TODO: match image sizes
                                    if jsonResponse.tracks.items.count > 0 {
                                        if jsonResponse.tracks.items[0].album.images.count > 0 {
                                            print("ok")
                                            print(jsonResponse.tracks.items[0].album.images[0].url)
                                            completion(jsonResponse.tracks.items[0].album.images[0].url)
                                        }
                                    }
                                    completion("")
                                    
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

