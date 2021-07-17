//
//  AuthViewModel.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/06/2021.
//

import Foundation
import SwiftUI
import NotificationBannerSwift

class AuthViewModel: ObservableObject {
    @AppStorage("lastfm_username") var storedUsername: String?
    @AppStorage("lastfm_sk") var storedToken: String?
    
    func isLoggedIn() -> Bool {
        return storedUsername != nil
    }
    
    func login(username: String, password: String) {
        LastFMAPI.request(lastFMMethod: "auth.getMobileSession", args: ["username": username,"password": password]) { (data: LoginResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to login", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
            
            if let data = data {
                print(data)
                self.storedToken = data.session.key
            }
        }
    }
}
