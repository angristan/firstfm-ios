//
//  SpotifyImage.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

import Foundation

struct SpotifyImage: Codable {
    var url: String
    var height: Int
    var width: Int

    static let DEFAULT_IMAGE = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"

    static func findImage(type: String, name: String, completion: @escaping (String?) -> Void) {
        if let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedName)&type=\(type)&limit=1"

            if let queryURL = URL(string: queryURLString) {
                var request = URLRequest(url: queryURL)

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                getSpotifyToken { spotifyToken in
                    print("spotifyToken: \(spotifyToken)")
                    request.setValue("Bearer \(spotifyToken)", forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                        do {
                            if let response = response {
                                let nsHTTPResponse = response as? HTTPURLResponse
                                if let statusCode = nsHTTPResponse?.statusCode {
                                    print("spotify status code = \(statusCode)")
                                }
                                // TODO
                            }

                            if let error = error {
                                print(error)
                                // TODO
                                completion(DEFAULT_IMAGE)
                            }

                            if let data = data {
                                if type == "track" {
                                    let jsonResponse = try JSONDecoder().decode(SpotifyTrackSearchResponse.self, from: data)

                                    if jsonResponse.tracks.items.count > 0 {
                                        if jsonResponse.tracks.items[0].album.images.count > 0 {
                                            completion(jsonResponse.tracks.items[0].album.images[0].url)
                                        } else {
                                            completion(DEFAULT_IMAGE)
                                        }
                                    } else {
                                        completion(DEFAULT_IMAGE)
                                    }
                                } else if type == "album" {
                                    let jsonResponse = try JSONDecoder().decode(SpotifyAlbumSearchResponse.self, from: data)

                                    if jsonResponse.albums.items.count > 0 {
                                        if jsonResponse.albums.items[0].images.count > 0 {
                                            completion(jsonResponse.albums.items[0].images[0].url)
                                        } else {
                                            completion(DEFAULT_IMAGE)
                                        }
                                    } else {
                                        completion(DEFAULT_IMAGE)
                                    }
                                } else if type == "artist" {
                                    let jsonResponse = try JSONDecoder().decode(SpotifyArtistSearchResponse.self, from: data)

                                    if jsonResponse.artists.items.count > 0 {
                                        if jsonResponse.artists.items[0].images.count > 0 {
                                            completion(jsonResponse.artists.items[0].images[0].url)
                                        } else {
                                            completion(DEFAULT_IMAGE)
                                        }
                                    } else {
                                        completion(DEFAULT_IMAGE)
                                    }
                                }
                            }
                        } catch {
                            print(error)
                            completion(DEFAULT_IMAGE)
                        }
                    }).resume()
                }
            }
        }
    }
}
