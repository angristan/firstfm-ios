//
//  LastFMAPI.swift
//  firstfm
//
//  Created by Nathanael Demacon on 7/9/21.
//

import Foundation

class LastFMAPI {
    // swiftlint:disable force_cast
    static let lastFMAPIKey = Bundle.main.object(forInfoDictionaryKey: "LastFMAPIKey") as! String
    
    static func request<T: Decodable>(method: String, lastFMMethod: String, config: [String : String] = [:], callback: @escaping (_ Data: T?, Error?) -> Void) -> Void {
        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)
        
        var configString = ""
        
        for (key, value) in config {
            configString += "&\(key)=\(value)"
        }
        
        let data : Data = "api_key=\(lastFMAPIKey)&method=\(lastFMMethod)\(configString)".data(using: .utf8)!
        
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            var callbackData: T? = nil
            var callbackError: Error? = nil

            do {
                if let response = response {
                    let nsHTTPResponse = response as? HTTPURLResponse
                    
                    if let statusCode = nsHTTPResponse?.statusCode {
                        print("status code = \(statusCode)")
                    }
                }
                
                if let error = error {
                    print(error)
                    callbackError = error
                }
                
                if let data = data {
                    let jsonResponse = try JSONDecoder().decode(T.self, from: data)
                    callbackData = jsonResponse
                }
            } catch {
                print(error)
                callbackError = error
            }
            
            callback(callbackData, callbackError)
        }.resume()
    }
}