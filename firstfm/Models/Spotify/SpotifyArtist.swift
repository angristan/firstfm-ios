import Foundation

struct SpotifyArtist: Codable {
    var name: String
    var id: String
    var images: [SpotifyImage]
}
