import Foundation
import CryptoSwift
import os

class LastFMAPI {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: LastFMAPI.self)
    )
    // swiftlint:disable force_cast
    static let lastFMAPIKey = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_KEY") as! String
    // swiftlint:disable force_cast
    static let lastFMSharedSecret = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_SHARED_SECRET") as! String

    static func request<T: Decodable>(method: String = "POST", lastFMMethod: String, args: [String: String] = [:], callback: @escaping (_ Data: T?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)

        // We need to add these into the dict to compute the signature
        var fullArgs = args
        fullArgs["method"] = lastFMMethod
        fullArgs["api_key"] = lastFMAPIKey

        var argsString = ""

        // Final format will be md5([param1][value1]..[paramN][valueN][shared_secret])
        // https://www.last.fm/api/mobileauth
        var toSign = ""

        for key in Array(fullArgs.keys).sorted(by: <) {
            if argsString != "" {
                // Not first param
                argsString += "&"
            }
            argsString += "\(key)=\(fullArgs[key] ?? "")"

            toSign += key
            toSign += fullArgs[key] ?? ""
        }

        toSign += lastFMSharedSecret

        let data: Data = "\(argsString)&api_sig=\(toSign.md5())".data(using: .utf8)!
        logger.info("Sending request with args: \(fullArgs)")

        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                    var callbackData: T?
                    var callbackError: Error?

                    do {
                        if let response = response {
                            let nsHTTPResponse = response as? HTTPURLResponse

                            if let statusCode = nsHTTPResponse?.statusCode {
                                logger.info("status code of request \(lastFMMethod): \(statusCode)")
                                if statusCode != 200 {
                                    if lastFMMethod == "user.getFriends" && statusCode == 400 {
                                        // The API returns a 400 when the user has no friends 🤨
                                        callback((FriendsResponse(friends: Friends(user: [])) as! T), nil)
                                        return
                                    }
                                    let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid API response 😢. Please try again"])
                                    callback(callbackData, error as Error)
                                    return
                                }
                            }
                        }

                        if let error = error {
                            logger.error("error for \(lastFMMethod): \(error.localizedDescription)")
                            callbackError = error
                        }

                        if let data = data {
                            let jsonResponse = try JSONDecoder().decode(T.self, from: data)
                            callbackData = jsonResponse
                        }
                    } catch {
                        logger.error("error for \(lastFMMethod): \(error.localizedDescription)")
                        callbackError = error
                    }

                    callback(callbackData, callbackError)
                }
                .resume()
    }
}
