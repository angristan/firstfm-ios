import Foundation
import NotificationBannerSwift
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var friends: [Friend] = []
    @Published var scrobbles: [ScrobbledTrack] = []
    @Published var topArtists: [Artist] = []
    @Published var topTracks: [Track] = []
    @Published var topAlbums: [TopAlbum] = []

    @Published var scrobblesPeriodPicked: Int = 5
    @Published var topTracksPeriodPicked: Int = 5
    @Published var topAlbumsPeriodPicked: Int = 5

    var isFriendsLoading = true
    //    var isLoading = true
    @AppStorage("lastfm_username") var storedUsername: String?
    let myValet = getValet()

    func getAll(username: String) {
        self.getProfile(username: username)
        self.getUserScrobbles(username: username)
        self.getTopArtists(username: username, period: "overall")
        self.getTopTracks(username: username, period: "overall")
        self.getTopAlbums(username: username, period: "overall")
        self.getFriends(username: username)
    }

    func getProfile(username: String) {
        LastFMAPI.request(lastFMMethod: "user.getInfo", args: ["user": username]) { (data: UserInfoResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load profile", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }

            if let data = data {
                var user = data.user
                if user.image[3].url == "" {
                    user.image[3].url = "https://bonds-and-shares.com/wp-content/uploads/2019/07/placeholder-user.png"
                }
                DispatchQueue.main.async {
                    self.user = user
                }
            }
        }
    }

    func getFriends(username: String) {
        LastFMAPI.request(lastFMMethod: "user.getFriends", args: ["user": username]) { (data: FriendsResponse?, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load friends", subtitle: error?.localizedDescription, style: .danger).show()
                }
            }

            if let data = data {
                var friends = data.friends.user

                for index in friends.indices {
                    if friends[index].image[3].url == "" {
                        friends[index].image[3].url = "https://bonds-and-shares.com/wp-content/uploads/2019/07/placeholder-user.png"
                    }
                }

                DispatchQueue.main.async {
                    self.friends = friends
                }
            }
            self.isFriendsLoading = false
        }
    }

    func getUserScrobbles(username: String) {
        //        self.isLoading = true
        let storedToken = try? myValet.string(forKey: "sk")

        LastFMAPI.request(lastFMMethod: "user.getRecentTracks", args: [
            "limit": "5",
            "extended": "1",
            "user": username,
            "sk": storedToken ?? ""
        ]) { (data: RecentTracksResponse?, error) -> Void in
            //            self.isLoading = false

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load scrobbles", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    (self.scrobbles = self.scrobbles)
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
                    SpotifyImageProxy.findImage(type: "track", name: "\(track.name) \(track.artist.name)") { imageURL in
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

    func getTopArtistsForPeriodTag(username: String, tag: Int) {
        // Reset artist to show placeholder
        self.topArtists = []

        switch tag {
        case 0:
            self.getTopArtists(username: username, period: "7day")
        case 1:
            self.getTopArtists(username: username, period: "1month")
        case 2:
            self.getTopArtists(username: username, period: "3month")
        case 3:
            self.getTopArtists(username: username, period: "6month")
        case 4:
            self.getTopArtists(username: username, period: "12month")
        default:
            self.getTopArtists(username: username, period: "overall")
        }
    }

    func getTopArtists(username: String, period: String) {
        LastFMAPI.request(lastFMMethod: "user.getTopArtists", args: ["user": username, "limit": "6", "period": period]) { (data: UserTopArtistsResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load artists", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    (self.topArtists = self.topArtists)
                }
            }

            if let data = data {
                var artists = data.topartists.artist

                for index in artists.indices where artists[index].image[0].url == "" {
                    artists[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.topArtists = artists
                }

                for (index, artist) in data.topartists.artist.enumerated() {
                    // Get image URL for each artist and trigger a View update through the observed object
                    SpotifyImageProxy.findImage(type: "artist", name: artist.name) { imageURL in
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

    func getTopTracksForPeriodTag(username: String, tag: Int) {
        // Reset tracks to show placeholder
        self.topTracks = []

        switch tag {
        case 0:
            self.getTopTracks(username: username, period: "7day")
        case 1:
            self.getTopTracks(username: username, period: "1month")
        case 2:
            self.getTopTracks(username: username, period: "3month")
        case 3:
            self.getTopTracks(username: username, period: "6month")
        case 4:
            self.getTopTracks(username: username, period: "12month")
        default:
            self.getTopTracks(username: username, period: "overall")
        }
    }

    func getTopTracks(username: String, period: String) {
        LastFMAPI.request(lastFMMethod: "user.getTopTracks", args: ["user": username, "limit": "5", "period": period]) { (data: ArtistTopTracksResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load tracks", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    (self.topTracks = self.topTracks)
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
                    SpotifyImageProxy.findImage(type: "track", name: track.name) { imageURL in
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

    func getTopAlbumsForPeriodTag(username: String, tag: Int) {
        // Reset tracks to show placeholder
        self.topAlbums = []

        switch tag {
        case 0:
            self.getTopAlbums(username: username, period: "7day")
        case 1:
            self.getTopAlbums(username: username, period: "1month")
        case 2:
            self.getTopAlbums(username: username, period: "3month")
        case 3:
            self.getTopAlbums(username: username, period: "6month")
        case 4:
            self.getTopAlbums(username: username, period: "12month")
        default:
            self.getTopAlbums(username: username, period: "overall")
        }
    }

    func getTopAlbums(username: String, period: String) {
        LastFMAPI.request(lastFMMethod: "user.getTopAlbums", args: ["user": username, "limit": "6", "period": period]) { (data: UserTopAlbumsResponse?, error) -> Void in

            if error != nil {
                DispatchQueue.main.async {
                    FloatingNotificationBanner(title: "Failed to load albums", subtitle: error?.localizedDescription, style: .danger).show()
                    // Force refresh, otherwise pull loader doesn't dismiss itself
                    (self.topAlbums = self.topAlbums)
                }
            }

            if let data = data {
                var albums = data.topalbums.album

                for index in albums.indices where albums[index].image[0].url == "" {
                    albums[index].image[0].url = "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp"
                }

                DispatchQueue.main.async {
                    self.topAlbums = albums
                }

                for (index, track) in data.topalbums.album.enumerated() {
                    SpotifyImageProxy.findImage(type: "album", name: track.name) { imageURL in
                        if let imageURL = imageURL {
                            DispatchQueue.main.async {
                                self.topAlbums[index].image[0].url = imageURL
                            }
                        }
                    }
                }
            }
        }
    }
}
