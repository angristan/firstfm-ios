import Foundation
import SwiftUI
import NotificationBannerSwift
import Valet

class AuthViewModel: ObservableObject {
    @AppStorage("lastfm_username") var storedUsername: String?
    let myValet = getValet()

    func isLoggedIn() -> Bool {
        return storedUsername != nil
    }

    func login(username: String, password: String) {
        LastFMAPI.request(lastFMMethod: "auth.getMobileSession", args: ["username": username, "password": password]) { (data: LoginResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to login", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }

            if let data = data {
                DispatchQueue.main.async {
                    try? self.myValet.setString(data.session.key, forKey: "sk")
                    FloatingNotificationBanner(title: "Successfully logged in", subtitle: "You can now browse your profile", style: .success).show()
                }
            }
        }
    }
}
