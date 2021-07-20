import Foundation

struct SpotifyAlbum: Codable {
    var name: String
    var id: String
    var images: [SpotifyImage]
}
