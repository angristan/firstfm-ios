import Foundation
import Cache
import os

struct SpotifyImageProxy: Codable {
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
            let queryURLString = "https://spotify-search-proxy.fly.dev/search/\(type)/\(encodedName)"

            if let queryURL = URL(string: queryURLString) {
                var request = URLRequest(url: queryURL)

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
                                        let jsonResponse = try JSONDecoder().decode(SpotifyTrackSearchResultResponse.self, from: data)
                                        if jsonResponse.album.images.count > 0 {
                                            completion(jsonResponse.album.images[0].url)
                                            try? storage?.setObject(jsonResponse.album.images[0], forKey: "\(type).\(name)")
                                        } else {
                                            completion(DefaultImage)
                                        }
                                    } else if type == "album" {
                                        let jsonResponse = try JSONDecoder().decode(SpotifyAlbum.self, from: data)

                                        if jsonResponse.images.count > 0 {
                                            completion(jsonResponse.images[0].url)
                                            try? storage?.setObject(jsonResponse.images[0], forKey: "\(type).\(name)")
                                        } else {
                                            completion(DefaultImage)
                                        }
                                    } else if type == "artist" {
                                        let jsonResponse = try JSONDecoder().decode(SpotifyArtist.self, from: data)

                                        if jsonResponse.images.count > 0 {
                                            completion(jsonResponse.images[0].url)
                                            try? storage?.setObject(jsonResponse.images[0], forKey: "\(type).\(name)")
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
