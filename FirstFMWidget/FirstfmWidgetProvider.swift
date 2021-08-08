import Foundation
import SwiftUI

class FirstfmWidgetProvider {
    @AppStorage("lastfm_username") var storedUsername: String?
    
    func getProfile(completion: ((UserInfoResponse) -> Void)?) {
        LastFMAPI.request(lastFMMethod: "user.getInfo", args: ["user": storedUsername ?? ""]) { (data: UserInfoResponse?, error) -> Void in
//            if error != nil {
//                DispatchQueue.main.async {
//                    FloatingNotificationBanner(title: "Failed to load profile", subtitle: error?.localizedDescription, style: .danger).show()
//                }
//            }
            
//            if let data = data {
//                var user = data.user
//                if user.image[3].url == "" {
//                    user.image[3].url = "https://bonds-and-shares.com/wp-content/uploads/2019/07/placeholder-user.png"
//                }
//                DispatchQueue.main.async {
//                    self.user = user
//                }
//            }
            
            if let data = data {
                completion!(data)
            }
        }
    }
}
