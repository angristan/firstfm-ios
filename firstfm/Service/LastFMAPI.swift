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
    // swiftlint:disable force_cast
    static let lastFMSharedSecret = Bundle.main.object(forInfoDictionaryKey: "LastFMSharedSecret") as! String

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

        let data: Data = "\(argsString)&api_sig=\(toSign.md5Value)".data(using: .utf8)!

        print("argsString: \(argsString)")
        print("toSign: \(toSign)")
        print("api_sig: \(toSign.md5Value)")

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
                        print("LastFMAPI status code = \(statusCode)")
                        if statusCode != 200 {
                            let error = NSError(domain: "", code: statusCode, userInfo: [ NSLocalizedDescriptionKey: "Invalid API response 😢. Please try again"])
                            callback(callbackData, error as Error)
                            return
                        }
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
