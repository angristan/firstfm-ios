//
//  SpotifyToken.swift
//  firstfm
//
//  Created by Stanislas Lange on 16/06/2021.
//

import Foundation

struct SpotifyCredentialsResponse: Codable {
    var access_token: String
    var expires_in: Int
}

func renewSpotifyToken(completion: @escaping (String) -> ()) {
    let authURL = "https://accounts.spotify.com/api/token"
    let SpotifyAPIToken = Bundle.main.object(forInfoDictionaryKey: "SpotifyAPIToken") as! String
    
    if let queryURL = URL(string: authURL) {
        var request = URLRequest(url: queryURL)
        
        request.setValue("Basic \(SpotifyAPIToken)",
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
                        defaults.set(jsonResponse.access_token, forKey: "spotify_token")
                        let expiresAt = Int64(Date().timeIntervalSince1970 * 1000) + Int64(jsonResponse.expires_in)
                        defaults.setValue(expiresAt, forKey: "spotify_expires")
                        completion(jsonResponse.access_token)
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
