import Foundation
import Cache
import os

struct SpotifyImage: Codable {
    var url: String
    var height: Int
    var width: Int

    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: LastFMAPI.self)
    )

    static let DefaultImage = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"

    static func findImage(type: String, name: String, completion: @escaping (String?) -> Void) {

        // MARK: Memoization handling START
        let diskConfig = DiskConfig(name: "firstfm.spotify.images")
        let memoryConfig = MemoryConfig()

        let storage = try? Storage<String, SpotifyImage>(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: SpotifyImage.self)
        )

        // If search API response is in memory/disk cache, let's save an API call!
        if let image = try? storage?.object(forKey: "\(type).\(name)") {
            completion(image.url)
            return
        }
        // MARK: Memoization handling END

        if let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedName)&type=\(type)&limit=1"

            if let queryURL = URL(string: queryURLString) {
                var request = URLRequest(url: queryURL)

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                SpotifyAPIService().getSpotifyToken { spotifyToken in
                    request.setValue("Bearer \(spotifyToken)", forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                                do {
                                    if let response = response {
                                        let nsHTTPResponse = response as? HTTPURLResponse
                                        if let statusCode = nsHTTPResponse?.statusCode {
                                            logger.log("findImage for \"\(name)\" (\(type)) status code = \(statusCode)")
                                            if statusCode != 200 {
                                                completion(DefaultImage)
                                            }
                                        }
                                        // TODO
                                    }

                                    if let error = error {
                                        logger.error("findImage error for \"\(name)\" (\(type)) = \(error.localizedDescription)")
                                        // TODO
                                        completion(DefaultImage)
                                    }

                                    if let data = data {
                                        if type == "track" {
                                            let jsonResponse = try JSONDecoder().decode(SpotifyTrackSearchResponse.self, from: data)

                                            if jsonResponse.tracks.items.count > 0 {
                                                if jsonResponse.tracks.items[0].album.images.count > 0 {
                                                    completion(jsonResponse.tracks.items[0].album.images[0].url)
                                                    try? storage?.setObject(jsonResponse.tracks.items[0].album.images[0], forKey: "\(type).\(name)")
                                                } else {
                                                    completion(DefaultImage)
                                                }
                                            } else {
                                                completion(DefaultImage)
                                            }
                                        } else if type == "album" {
                                            let jsonResponse = try JSONDecoder().decode(SpotifyAlbumSearchResponse.self, from: data)

                                            if jsonResponse.albums.items.count > 0 {
                                                if jsonResponse.albums.items[0].images.count > 0 {
                                                    completion(jsonResponse.albums.items[0].images[0].url)
                                                    try? storage?.setObject(jsonResponse.albums.items[0].images[0], forKey: "\(type).\(name)")
                                                } else {
                                                    completion(DefaultImage)
                                                }
                                            } else {
                                                completion(DefaultImage)
                                            }
                                        } else if type == "artist" {
                                            let jsonResponse = try JSONDecoder().decode(SpotifyArtistSearchResponse.self, from: data)

                                            if jsonResponse.artists.items.count > 0 {
                                                if jsonResponse.artists.items[0].images.count > 0 {
                                                    completion(jsonResponse.artists.items[0].images[0].url)
                                                    try? storage?.setObject(jsonResponse.artists.items[0].images[0], forKey: "\(type).\(name)")
                                                } else {
                                                    completion(DefaultImage)
                                                }
                                            } else {
                                                completion(DefaultImage)
                                            }
                                        }
                                    }
                                } catch {
                                    logger.error("findImage error for \"\(name)\" (\(type)) = \(String(describing: error))")
                                    completion(DefaultImage)
                                }
                            })
                            .resume()
                }
            }
        }
    }
}
