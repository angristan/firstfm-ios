import Foundation
import NotificationBannerSwift

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var friends: [Friend] = []
    var isFriendsLoading = true
    var isLoading = true

    func getProfile(username: String) {
        self.isLoading = true

        LastFMAPI.request(lastFMMethod: "user.getInfo", args: ["user": username]) { (data: UserInfoResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load profile", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
            self.isLoading = false

            if let data = data {
                DispatchQueue.main.async {
                    self.user = data.user
                }
            }
        }
    }

    func getFriends(username: String) {
        self.isFriendsLoading = true

        LastFMAPI.request(lastFMMethod: "user.getFriends", args: ["user": username]) { (data: FriendsResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load friends", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
            self.isFriendsLoading = false

            if let data = data {
                DispatchQueue.main.async {
                    self.friends = data.friends.user
                }
            }
        }
    }
}
