import Foundation
import SwiftUI

struct SpotifyCredentialsResponse: Codable {
    var accessToken: String
    var expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}

class SpotifyAPIService {

    @AppStorage("spotify_tmp_token") var spotifyToken: String?
    @AppStorage("spotify_expires_at") var spotifyExpiresAt: String?

    func renewSpotifyToken(completion: @escaping (String) -> Void) {
        let authURL = "https://accounts.spotify.com/api/token"
        // swiftlint:disable force_cast
        let spotifyAPIToken = Bundle.main.object(forInfoDictionaryKey: "SPOTIFY_API_TOKEN") as! String

        if let queryURL = URL(string: authURL) {
            var request = URLRequest(url: queryURL)

            request.setValue("Basic \(spotifyAPIToken)",
                    forHTTPHeaderField: "Authorization")

            let data: Data = "grant_type=client_credentials".data(using: .utf8)!

            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = data

            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                        do {
                            if let response = response {
                                let nsHTTPResponse = response as? HTTPURLResponse
                                if let statusCode = nsHTTPResponse?.statusCode {
                                    print("renewSpotifyToken status code = \(statusCode)")
                                }
                                // TODO
                            }
                            if let error = error {
                                print(error)
                                // TODO
                                completion("")
                            }
                            if let data = data {
                                do {
                                    let jsonResponse = try JSONDecoder().decode(SpotifyCredentialsResponse.self, from: data)
                                    self.spotifyToken = jsonResponse.accessToken
                                    self.spotifyExpiresAt = String(Int64(Date().timeIntervalSince1970) + Int64(jsonResponse.expiresIn))
                                    completion(jsonResponse.accessToken)
                                }
                            }
                        } catch {
                            print(error)
                            // TODO
                        }
                    })
                    .resume()
        }
    }

    func getSpotifyToken(completion: @escaping (String) -> Void) {
        let currentTimeSeconds = Int64(Date().timeIntervalSince1970)

        if spotifyToken == nil || Int64(spotifyExpiresAt ?? "0") == 0 {
            renewSpotifyToken { renewedToken in
                completion(renewedToken)
            }

        } else {
            // We want the refresh token to be valid for at least 30s
            if Int64(spotifyExpiresAt ?? "0") != 0 && currentTimeSeconds + 30 > Int64(spotifyExpiresAt ?? "0") ?? 0 {
                renewSpotifyToken { renewedToken in
                    completion(renewedToken)

                }
            }
        }

        if let token = spotifyToken {
            completion(token)
        }
        completion("")
    }
}
