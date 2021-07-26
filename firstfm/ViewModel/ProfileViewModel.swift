import Foundation
import NotificationBannerSwift
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var friends: [Friend] = []
    @Published var scrobbles: [ScrobbledTrack] = []
    @Published var topArtists: [Artist] = []
    @Published var scrobblesPeriodPicked: Int = 5
    @Published var topTracksPeriodPicked: Int = 5
    @Published var topTracks: [Track] = []
    var isFriendsLoading = true
    //    var isLoading = true
    @AppStorage("lastfm_username") var storedUsername: String?
    let myValet = getValet()

    func getAll(_ username: String) {
        //        reset()

        self.getProfile(username)
        self.getUserScrobbles()
        self.getTopArtists(period: "overall")
        self.getTopTracks(period: "overall")
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
            "limit": "5",
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

    func getTopArtistsForPeriodTag(tag: Int) {
        // Reset artist to show placeholder
        self.topArtists = []

        switch tag {
        case 0:
            self.getTopArtists(period: "7day")
        case 1:
            self.getTopArtists(period: "1month")
        case 2:
            self.getTopArtists(period: "3month")
        case 3:
            self.getTopArtists(period: "6month")
        case 4:
            self.getTopArtists(period: "12month")
        default:
            self.getTopArtists(period: "overall")
        }
    }

    func getTopArtists(period: String) {
        LastFMAPI.request(lastFMMethod: "user.getTopArtists", args: ["user": storedUsername ?? "", "limit": "6", "period": period]) { (data: UserTopArtistsResponse?, error) -> Void in

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

                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                        if let imageURL = imageURL {
                            //                            DispatchQueue.main.async {
                            artists[index].image[0].url = imageURL
                            //                            }
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.topArtists = artists
                    //                    self.isLoading = false
                }
            }
        }
    }

    func getTopTracksForPeriodTag(tag: Int) {
        // Reset tracks to show placeholder
        self.topTracks = []

        switch tag {
        case 0:
            self.getTopTracks(period: "7day")
        case 1:
            self.getTopTracks(period: "1month")
        case 2:
            self.getTopTracks(period: "3month")
        case 3:
            self.getTopTracks(period: "6month")
        case 4:
            self.getTopTracks(period: "12month")
        default:
            self.getTopTracks(period: "overall")
        }
    }

    func getTopTracks(period: String) {
        LastFMAPI.request(lastFMMethod: "user.getTopTracks", args: ["user": storedUsername ?? "", "limit": "5", "period": period]) { (data: ArtistTopTracksResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load charts", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    self.topTracks = self.topTracks
                }
            }

            if let data = data {
                var tracks = data.toptracks.track

                for index in tracks.indices where tracks[index].image[0].url == "" {
                    tracks[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.topTracks = tracks
                }

                for (index, track) in data.toptracks.track.enumerated() {
                    SpotifyImage.findImage(type: "track", name: track.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.topTracks[index].image[0].url = imageURL
                            }

                        }
                    }
                }
            }
        }
    }
}
