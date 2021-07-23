import Foundation
import NotificationBannerSwift
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var friends: [Friend] = []
    @Published var scrobbles: [ScrobbledTrack] = []
    @Published var topArtists: [Artist] = []
    var isFriendsLoading = true
//    var isLoading = true
    @AppStorage("lastfm_username") var storedUsername: String?
    let myValet = getValet()

    func getAll(_ username: String) {
//        reset()

        self.getProfile(username)
        self.getUserScrobbles()
        self.getTopArtists()
    }

    func getProfile(_ username: String) {
//        self.isLoading = true

        LastFMAPI.request(lastFMMethod: "user.getInfo", args: ["user": username]) { (data: UserInfoResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load profile", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
//            self.isLoading = false

            if let data = data {
                DispatchQueue.main.async {
                    self.user = data.user
                }
            }
        }
    }

    func getFriends(_ username: String) {
//        self.isFriendsLoading = true

        LastFMAPI.request(lastFMMethod: "user.getFriends", args: ["user": username]) { (data: FriendsResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load friends", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }
//            self.isFriendsLoading = false

            if let data = data {
                DispatchQueue.main.async {
                    self.friends = data.friends.user
                }
            }
        }
    }

    func getUserScrobbles() {
//        self.isLoading = true
        let storedToken = try? myValet.string(forKey: "sk")

        LastFMAPI.request(lastFMMethod: "user.getRecentTracks", args: [
            "limit": "4",
            "extended": "1",
            "user": storedUsername ?? "",
            "sk": storedToken ?? ""
        ]) { (data: RecentTracksResponse?, error) -> Void in
//            self.isLoading = false

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load scrobbles", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.scrobbles = self.scrobbles
                }
            }

            if let data = data {
                var tracks = data.recentTracks.track

                // Fix tracks that don't have images

                for index in tracks.indices {
                    if tracks[index].image[0].url == "" {
                        tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }

                    if tracks[index].image[3].url == "" {
                        tracks[index].image[3].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                    }
                }

                DispatchQueue.main.async {
                    self.scrobbles = tracks
                }

                for (index, track) in tracks.enumerated() {
                    // Get image URL for each track and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "track", name: "\(track.name) \(track.artist.name)") { imageURL in
                        if let imageURL = imageURL {
                            tracks[index].image[0].url = imageURL
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.scrobbles = tracks
                }

            }
        }
    }

    func getTopArtists() {

        LastFMAPI.request(lastFMMethod: "user.getTopArtists", args: ["user": storedUsername ?? "", "limit": "6", "period": "overall"]) { (data: UserTopArtistsResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load charts", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.topArtists = self.topArtists
                }
            }

            if let data = data {
                var artists = data.topartists.artist

                for index in artists.indices where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.topArtists = artists
//                    self.isLoading = false
                }

                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.topArtists[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}