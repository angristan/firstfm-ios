import Foundation

struct TopAlbum: Codable {
    let artist: ScrobbledArtist
    var image: [LastFMImage]
    let playcount: String
    let url: String
    let name, mbid: String
}
