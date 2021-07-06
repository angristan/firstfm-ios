//
//  UserViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 06/07/2021.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    var isLoading = true
    
    let lastFMAPIKey = Bundle.main.object(forInfoDictionaryKey: "LastFMAPIKey") as! String
    
    func getProfile(username: String) {
        self.isLoading = true
        
        var request = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?format=json")!)
        
        let data : Data = "api_key=\(lastFMAPIKey)&method=user.getInfo&user=\(username)".data(using: .utf8)!
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.httpBody = data
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
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
                }
                if let data = data {
                    do{
                        let jsonResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.user = jsonResponse.user
                            self.isLoading = false
                        }
                    }
                }
            }
            catch {
                print(error)
                // TODO
            }
        }.resume()
    }
}
