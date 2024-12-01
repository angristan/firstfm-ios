import Foundation
import CryptoSwift
import os

class LastFMAPI {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LastFMAPI.self)
    )

    static let lastFMAPIKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_KEY") as? String else {
            fatalError("LASTFM_API_KEY not found in Info.plist")
        }
        return apiKey
    }()

    static let lastFMSharedSecret: String = {
        guard let sharedSecret = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_SHARED_SECRET") as? String else {
            fatalError("LASTFM_API_SHARED_SECRET not found in Info.plist")
        }
        return sharedSecret
    }()

    static func request<T: Decodable>(method: String = "POST", lastFMMethod: String, args: [String: String] = [:], callback: @escaping (_ data: T?, _ error: Error?) -> Void) {
        var fullArgs = args
        fullArgs["method"] = lastFMMethod
        fullArgs["api_key"] = lastFMAPIKey

        // Format of signature is md5([param1][value1]..[paramN][valueN][shared_secret])
        // https://www.last.fm/api/mobileauth
        let signature = fullArgs.sorted(by: { $0.key < $1.key }).reduce("") { $0 + $1.key + $1.value } + lastFMSharedSecret
        fullArgs["api_sig"] = signature.md5()

        var components = URLComponents(string: "https://ws.audioscrobbler.com/2.0/")!
        components.queryItems = fullArgs.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems?.append(URLQueryItem(name: "format", value: "json"))

        guard let url = components.url else {
            logger.error("Failed to create URL")
            callback(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        logger.info("Sending request with args: \(fullArgs)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            var callbackData: T?
            var callbackError: Error?

            if let error = error {
                logger.error("Error for \(lastFMMethod): \(String(describing: error))")
                callbackError = error
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                logger.info("Status code of request \(lastFMMethod): \(response.statusCode)")
                if lastFMMethod == "user.getFriends" && response.statusCode == 400 {
                    // The API returns a 400 when the user has no friends 🤨
                    if let friendsResponse = FriendsResponse(friends: Friends(user: [])) as? T {
                        callback(friendsResponse, nil)
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast FriendsResponse to expected type"])
                        callback(nil, error)
                    }
                    return
                }

                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid last.fm API response 😢. Please try again"])
                callback(nil, error)
                return
            } else if let data = data {
                do {
                    callbackData = try JSONDecoder().decode(T.self, from: data)
                } catch {
                    logger.error("Error decoding response for \(lastFMMethod): \(String(describing: error))")
                    callbackError = error
                }
            }

            callback(callbackData, callbackError)
        }.resume()
    }
}
