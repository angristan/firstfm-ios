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

    func getUserScrobbles() {
        self.isLoading = true
        
        LastFMAPI.request(lastFMMethod: "user.getRecentTracks", args: [
            "limit": "30",
            "extended": "1",
            "user": storedUsername ?? "",
        ]) { (data: RecentTracksResponse?, error) -> Void in
            self.isLoading = false
            
            if let data = data {
                var tracks = data.recentTracks.track
                
                // Fix tracks that don't have images
                
                for (index, _) in tracks.enumerated() {
                    if tracks[index].image[0].url == "" {
                        tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                    
                    if tracks[index].image[3].url == "" {
                        tracks[index].image[3].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.scrobbles = tracks
                    print(self.scrobbles)
                    
                    // Let's stop the loader, the images will be loaded aynchronously
                    self.isLoading = false
                }
                
                for (index, track) in tracks.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    self.getImageForTrack(trackName: track.name, artistName: track.artist.name) { imageURL in
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
    
    func getImageForTrack(trackName: String, artistName: String, completion: @escaping (String?) -> ()) {
        if let encodedTrackName = "\(trackName) \(artistName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
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

