//
//  SpotifyToken.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

import Foundation

struct SpotifyCredentialsResponse: Codable {
    var accessToken: String
    var expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}

func renewSpotifyToken(completion: @escaping (String) -> ()) {
    let authURL = "https://accounts.spotify.com/api/token"
    // swiftlint:disable force_cast
    let spotifyAPIToken = Bundle.main.object(forInfoDictionaryKey: "SpotifyAPIToken") as! String

    if let queryURL = URL(string: authURL) {
        var request = URLRequest(url: queryURL)

        request.setValue("Basic \(spotifyAPIToken)",
                         forHTTPHeaderField:"Authorization");

        let data : Data = "grant_type=client_credentials".data(using: .utf8)!

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = data

        URLSession.shared.dataTask(with: request , completionHandler : { data, response, error in
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
                    completion("")
                }
                if let data = data {
                    do{
                        let jsonResponse = try JSONDecoder().decode(SpotifyCredentialsResponse.self, from: data)
                        let defaults = UserDefaults.standard
                        defaults.set(jsonResponse.accessToken, forKey: "spotify_token")
                        let expiresAt = Int64(Date().timeIntervalSince1970 * 1000) + Int64(jsonResponse.expiresIn)
                        defaults.setValue(expiresAt, forKey: "spotify_expires")
                        completion(jsonResponse.accessToken)
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

func getSpotifyToken(completion: @escaping (String) -> ()) {
    let defaults = UserDefaults.standard
    let storedToken = defaults.string(forKey: "spotify_token")
    let expiresAt = defaults.integer(forKey: "spotify_expires")
    let currentTimeSeconds = Int64(Date().timeIntervalSince1970 * 1000)


    if storedToken == nil || expiresAt == 0 {
        renewSpotifyToken() { renewedToken in
            completion(renewedToken)
        }

    } else {
        // We want the refresh token to be valid for at least 30s
        if expiresAt != 0 && currentTimeSeconds + 30 > expiresAt {
            renewSpotifyToken() { renewedToken in
                completion(renewedToken)

            }
        }
    }

    if let token = storedToken {
        completion(token)
    }
    completion("")
}
